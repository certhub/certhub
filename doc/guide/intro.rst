Intro
=====

Thanks to Let's Encrypt and Certbot the number of TLS enabled sites is growing
faster than ever. Transport encryption is becoming ubiquitous leading to much
better security on the user facing web.

Many of the available ACME clients (including Certbot) made it a top priority
to very well support monolithic systems which are managed manually. As a result
ACME client software commonly assumes that it has access to TLS private keys,
privileged ports or the web servers configuration files in order to make the
process of obtaining a certificate as smooth as possible.

Admittedly this simplifies the life of inexperienced system administrators. But
the lack of proper privilege separation also poses a risk to the systems
integrity.

Let's Encrypt certificates have a very limited life-span of 90 days. Therefore
it is crucial to automate certificate renewal as well. Most ACME clients employ
some mechanism to track the state of issued certificates and trigger a timely
renewal. In order to allow for rollbacks, ACME clients often archive previous
versions of certificates in some directory structure.

As a result some state needs to be backed up and preseeded when a system gets
rebuilt. With the rise of IT automation, containers and virtual machines are
built and deployed more frequently. Keeping software state across those builds
in various vendor specific formats is inconvenient.


Configuration
-------------

Certhub strictly separates (read-only) configuration from (read-write) state.
As a result it naturally integrates well with configuration management and IT
automation systems.


State
-----

Instead of maintaining an ad-hoc directory structure of current and previous
certificates, Certhub keeps track of them using a git repository.

Certhub provides a simple utility to check for certificates which are about to
expire. The predefined action is to trigger the certificate renewal job if an
outdated certificate is detected. Both, the expiry check and the renewal job
do operate on temporary checkouts of the git repository.


Replication
-----------

Keeping certificates in a repository also makes it easier to replicate fresh
certificates to other machines or make them available for new deployments on a
repository hosting service.

There is a large body of CI/CD systems which integrate well with git. With
Certhub a certificate renewal results in a new commit to the repository. Thus
existing automation infrastructure can be leveraged to trigger builds and
deployments without hooking into ACME client software directly.


Separation
----------

Granted that Certhub takes over state management, repository replication and
expiry checks, the only thing left for the actual ACME client is to obtain
certificates.

Some ACME clients support an operation mode where access to the TLS private key
is not necessary. A CSR is taken as the input and the resulting certificate is
written to an output file. This operation can be performed without elevated
privileges. Certhub currently supports Certbot, Dehydrated and Lego in
unprivileged CSR mode.

Note that this mode of operation simplifies centralized certificate management
where the ACME client is only installed on one or few machines separated from
the systems which are running the actual TLS servers.
