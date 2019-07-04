from __future__ import absolute_import, division, unicode_literals

import os
import shutil
import subprocess
import tempfile
import unittest

class SendTestCase(unittest.TestCase):
    workdir = None

    def _cmd(self, *args, **kwds):
        kwds.setdefault("cwd", self.workdir)
        return subprocess.check_output(args, **kwds)

    def setUp(self):
        self.workdir = tempfile.mkdtemp()

    def tearDown(self):
        if self.workdir is not None:
            shutil.rmtree(self.workdir)

    def testWithInput(self):
        inputpath = os.path.join(self.workdir, "input")
        outputpath = os.path.join(self.workdir, "output")

        with open(inputpath, "wb") as stream:
            stream.write(b"stuff")

        self._cmd("certhub-send-file", inputpath, "/usr/bin/tee", outputpath)
        self.assertTrue(os.path.exists(outputpath))

        with open(outputpath, "rb") as stream:
            content = stream.read()

        self.assertEqual(b"stuff", content)
