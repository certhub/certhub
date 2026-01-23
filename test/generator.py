from __future__ import absolute_import, division, unicode_literals

import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

class GeneratorTestCase(unittest.TestCase):
    workdir = None
    sourceUnits = Path()
    generatedUnits = Path()

    def _cmd(self, *args, **kwds):
        kwds.setdefault("cwd", self.workdir)
        return subprocess.check_output(args, **kwds)

    def setUp(self):
        self.workdir = tempfile.mkdtemp()
        self.sourceUnits = Path(self.workdir).joinpath("source-units")
        self.sourceUnits.mkdir()
        self.generatedUnits = Path(self.workdir).joinpath("generated-units")
        self.generatedUnits.mkdir()

    def tearDown(self):
        if self.workdir is not None:
            shutil.rmtree(self.workdir)

    def testAcmeGenerator(self):
        self.sourceUnits.joinpath("test.example.com.certbot").touch()
        self.sourceUnits.joinpath("other.example.com.lego").touch()
        self.sourceUnits.joinpath("third.example.com.dehydrated").touch()

        env = dict(**os.environ)
        env["CERTHUB_UNIT_DIR"] = self.sourceUnits
        output = self._cmd("certhub-acme-generator", self.generatedUnits, env=env)
        self.assertTrue(Path(self.generatedUnits.joinpath("paths.target.wants/certhub-certbot-run@test.example.com.path")).is_symlink())
        self.assertTrue(Path(self.generatedUnits.joinpath("paths.target.wants/certhub-dehydrated-run@third.example.com.path")).is_symlink())
        self.assertTrue(Path(self.generatedUnits.joinpath("paths.target.wants/certhub-lego-run@other.example.com.path")).is_symlink())
        self.assertTrue(Path(self.generatedUnits.joinpath("timers.target.wants/certhub-cert-expiry@other.example.com.timer")).is_symlink())
        self.assertTrue(Path(self.generatedUnits.joinpath("timers.target.wants/certhub-cert-expiry@test.example.com.timer")).is_symlink())
        self.assertTrue(Path(self.generatedUnits.joinpath("timers.target.wants/certhub-cert-expiry@third.example.com.timer")).is_symlink())

        self.assertEqual(b"", output)

    def testCertGenerator(self):
        self.sourceUnits.joinpath("test.example.com.cert").touch()
        self.sourceUnits.joinpath("other.example.com.cert").touch()

        env = dict(**os.environ)
        env["CERTHUB_UNIT_DIR"] = self.sourceUnits
        output = self._cmd("certhub-cert-generator", self.generatedUnits, env=env)
        self.assertTrue(Path(self.generatedUnits.joinpath("paths.target.wants/certhub-cert-export@test.example.com.path")).is_symlink())
        self.assertTrue(Path(self.generatedUnits.joinpath("paths.target.wants/certhub-cert-export@other.example.com.path")).is_symlink())

    def testPushGenerator(self):
        self.sourceUnits.joinpath(r"certhub\x40test.example.com:-var-lib-certhub-certs.git.push").touch()
        self.sourceUnits.joinpath(r"git\x40gitlab.com:certhub\x2dgitlab\x2ddemo-certs.git.push").touch()

        env = dict(**os.environ)
        env["CERTHUB_UNIT_DIR"] = self.sourceUnits
        output = self._cmd("certhub-push-generator", self.generatedUnits, env=env)
        self.assertTrue(Path(self.generatedUnits.joinpath(r"paths.target.wants/certhub-repo-push@certhub\x40test.example.com:-var-lib-certhub-certs.git.path")).is_symlink())
        self.assertTrue(Path(self.generatedUnits.joinpath(r"paths.target.wants/certhub-repo-push@git\x40gitlab.com:certhub\x2dgitlab\x2ddemo-certs.git.path")).is_symlink())

    def testSendGenerator(self):
        self.sourceUnits.joinpath("test.example.com.send").touch()
        self.sourceUnits.joinpath("other.example.com.send").touch()

        env = dict(**os.environ)
        env["CERTHUB_UNIT_DIR"] = self.sourceUnits
        output = self._cmd("certhub-send-generator", self.generatedUnits, env=env)
        self.assertTrue(Path(self.generatedUnits.joinpath(r"paths.target.wants/certhub-cert-send@test.example.com.path")).is_symlink())
        self.assertTrue(Path(self.generatedUnits.joinpath(r"paths.target.wants/certhub-cert-send@other.example.com.path")).is_symlink())
