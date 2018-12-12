from __future__ import absolute_import, division, unicode_literals

import datetime
import functools
import itertools
import sys

from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa

def genkey(bits=512):
    return rsa.generate_private_key(
        public_exponent=65537,
        key_size=bits,
        backend=default_backend()
    )

def keywrite(key, path):
    with open(path, "wb") as stream:
        stream.write(key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.TraditionalOpenSSL,
        encryption_algorithm=serialization.NoEncryption()))

def gencert(key, days=10, date_start=datetime.datetime.utcnow()):
    # Generate self signed certificate.
    subject = issuer = x509.Name([
        x509.NameAttribute(x509.oid.NameOID.COUNTRY_NAME, u"US"),
        x509.NameAttribute(x509.oid.NameOID.STATE_OR_PROVINCE_NAME, u"CA"),
        x509.NameAttribute(x509.oid.NameOID.LOCALITY_NAME, u"San Francisco"),
        x509.NameAttribute(x509.oid.NameOID.ORGANIZATION_NAME, u"My Company"),
        x509.NameAttribute(x509.oid.NameOID.COMMON_NAME, u"localhost"),
    ])

    return x509.CertificateBuilder().subject_name(
        subject
    ).issuer_name(
        issuer
    ).public_key(
        key.public_key()
    ).serial_number(
        x509.random_serial_number()
    ).not_valid_before(
        date_start
    ).not_valid_after(
        date_start + datetime.timedelta(days=days)
    ).sign(key, hashes.SHA256(), default_backend())

def certfp(cert):
    if sys.version_info[0] > 2:
        _iterbytes = iter
    else:
        _iterbytes = functools.partial(itertools.imap, ord)

    hexbytes = ["{:02x}".format(b).upper() for b in _iterbytes(cert.fingerprint(hashes.SHA256()))]
    return "SHA256 Fingerprint={:s}\n".format(":".join(hexbytes)).encode()

def certwrite(cert, path):
    with open(path, "wb") as stream:
        stream.write(cert.public_bytes(serialization.Encoding.PEM))
