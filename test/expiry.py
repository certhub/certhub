from __future__ import absolute_import, division, unicode_literals

import os
import shutil
import subprocess
import tempfile
import unittest

from .cert import *

DAY = 24 * 3600

class ExpiryTestCase(unittest.TestCase):
    workdir = None

    def _cmd(self, *args, **kwds):
        kwds.setdefault("cwd", self.workdir)
        return subprocess.check_output(args, **kwds)

    def setUp(self):
        self.workdir = tempfile.mkdtemp()

    def tearDown(self):
        if self.workdir is not None:
            shutil.rmtree(self.workdir)

    def testNonExpiredCert(self):
        certpath = os.path.join(self.workdir, "cert.pem")
        certwrite(gencert(genkey(), days=30), certpath)

        output = self._cmd("certhub-cert-expiry", certpath, str(10 * DAY),
                           "/bin/echo", "Output unexpected")

        self.assertEqual(b"", output)

    def testExpiredCert(self):
        certpath = os.path.join(self.workdir, "cert.pem")
        certwrite(gencert(genkey(), days=1), certpath)

        output = self._cmd("certhub-cert-expiry", certpath, str(10 * DAY),
                           "/bin/echo", "Certificate will expire within 10 days")

        self.assertEqual(b"Certificate will expire within 10 days\n", output)

    def testPropagatesStatus(self):
        certpath = os.path.join(self.workdir, "cert.pem")
        certwrite(gencert(genkey(), days=1), certpath)

        self.assertRaises(subprocess.CalledProcessError, self._cmd,
                          "certhub-cert-expiry", certpath, str(10 * DAY),
                          "/bin/false")

    def testFailsOnInvalidCert(self):
        # Generate a private key and write it to the cert file in order to test
        # for behavior when command is given an invalid file.
        certpath = os.path.join(self.workdir, "cert.pem")
        keywrite(genkey(), certpath)

        self.assertRaises(subprocess.CalledProcessError, self._cmd,
                          "certhub-cert-expiry", certpath, str(10 * DAY),
                          "/bin/echo", "Certificate will expire within 10 days")

    def testFailsOnMissingInputFile(self):
        certpath = os.path.join(self.workdir, "cert.pem")

        self.assertRaises(subprocess.CalledProcessError, self._cmd,
                          "certhub-cert-expiry", certpath, str(10 * DAY),
                          "/bin/echo", "Certificate will expire within 10 days")

    def testSuppressesCommandForNonExpiredCert(self):
        certpath = os.path.join(self.workdir, "cert.pem")
        certwrite(gencert(genkey(), days=30), certpath)

        output = self._cmd("certhub-cert-expiry", certpath, str(10 * DAY),
                           "/bin/false")

        self.assertEqual(b"", output)
