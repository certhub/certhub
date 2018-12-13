from __future__ import absolute_import, division, unicode_literals

import os
import shutil
import subprocess
import tempfile
import unittest

class StatusfileTestCase(unittest.TestCase):
    workdir = None

    def _cmd(self, *args, **kwds):
        kwds.setdefault("cwd", self.workdir)
        return subprocess.check_output(args, **kwds)

    def setUp(self):
        self.workdir = tempfile.mkdtemp()

    def tearDown(self):
        if self.workdir is not None:
            shutil.rmtree(self.workdir)

    def testWithoutOutput(self):
        statuspath = os.path.join(self.workdir, "status")
        self._cmd("certhub-status-file", statuspath, "/bin/true")
        self.assertFalse(os.path.exists(statuspath))

    def testWithOutput(self):
        statuspath = os.path.join(self.workdir, "status")
        self._cmd("certhub-status-file", statuspath, "/bin/echo",
                 "Certificate will expire within 10 days")
        self.assertTrue(os.path.exists(statuspath))

        with open(statuspath, "rb") as stream:
            content = stream.read()

        self.assertEqual(b"Certificate will expire within 10 days\n", content)

    def testEmptyOutputRemovesExistingFile(self):
        statuspath = os.path.join(self.workdir, "status")

        with open(statuspath, "wb") as stream:
            stream.write(b"stuff")

        self.assertTrue(os.path.exists(statuspath))

        self._cmd("certhub-status-file", statuspath, "/bin/true")
        self.assertFalse(os.path.exists(statuspath))

    def testPropagatesStatus(self):
        statuspath = os.path.join(self.workdir, "status")

        self.assertRaises(subprocess.CalledProcessError, self._cmd,
                          "certhub-status-file", statuspath,
                          "/bin/false")
        self.assertFalse(os.path.exists(statuspath))

    def testFailPreservesExistingFile(self):
        statuspath = os.path.join(self.workdir, "status")

        with open(statuspath, "wb") as stream:
            stream.write(b"stuff")

        self.assertTrue(os.path.exists(statuspath))

        self.assertRaises(subprocess.CalledProcessError, self._cmd,
                          "certhub-status-file", statuspath,
                          "/bin/false")
        self.assertTrue(os.path.exists(statuspath))

        with open(statuspath, "rb") as stream:
            output = stream.read()

        self.assertEqual(output, b"stuff")
