Overview
========


System architecture
-------------------

A typical certhub deployment consists of one *Controller* node hosting the
*ACME Client* (i.e., ``Certbot``, ``Dehydrated`` or ``Lego``) along with the
*Principal Git Repository*. Multiple *TLS Server* nodes are used to host *TLS
Services* such as web servers, mail servers, databases and application servers.

The *ACME Client* stores certificates optained from the *Certificate Authority*
in the *Principal Git Repository*. Changes to that repo are replicated to the
*Local Git Repositories* on the *TLS Server* nodes automatically.

Certificates in the *Local Certificate Directory* on a *TLS Server* node are
updated automatically whenever new commits are pushed to the *Local Git
Repository*.

*TLS Services* are reloaded whenever the exported certificate in the *Local
Certificate Directory* is modified.

Note that *ACME Account Key* is only needed on the *Controller* node (readable
by the *ACME Client*). Also *TLS Private Keys* are only deployed on the
respective *TLS Server* nodes and are readable by their respective *TLS
services* exclusively.

.. uml::

   cloud {
      [Certificate Authority]
      note bottom of [Certificate Authority]: E.g., Let's Encrypt

      [Challenge Server]
      [Certificate Authority] -> [Challenge Server] : verify
      note bottom of [Challenge Server]: DNS-01 / HTTP-01\nchallenge tokens\nare deployed to\nthis Service
   }

   node "Controller" {
      [ACME Client] --> [Principal Git Repository] : update cert
      [ACME Client] ..> [ACME Account Key] : use
      [ACME Client] -> [Certificate Authority] : optain cert
      [ACME Client] -> [Challenge Server] : deploy challenge
      [ACME Account Key] #Lightsalmon
   }

   node "TLS Server A" {
      [Principal Git Repository] --> [Local Git Repository A] : push
      [Local Git Repository A] --> [Local Certificate Directory A] : export
      [Local Certificate Directory A] --> [TLS Service A] : reload
      [TLS Service A] ..> [TLS Private Key A] : use
      [TLS Private Key A] #Lightsalmon
   }

   node "TLS Server B" {
      [Principal Git Repository] --> [Local Git Repository B] : push
      [Local Git Repository B] --> [Local Certificate Directory B] : export
      [Local Certificate Directory B] --> [TLS Service B.1] : reload
      [Local Certificate Directory B] --> [TLS Service B.2] : reload
      [TLS Service B.1] ..> [TLS Private Key B.1] : use
      [TLS Service B.2] ..> [TLS Private Key B.2] : use
      [TLS Private Key B.1] #Lightsalmon
      [TLS Private Key B.2] #Lightsalmon
   }


Certhub ships with a considerable number of systemd units. All of those are
designed as templates. Units used for replication to other nodes use the
destination for the template instance string, all other units take a certificate
basename as their instance string. The following diagram depicts a typical
setup featuring automatic renewal, replication, certificate export and TLS
service reload.

.. uml::

   node "Controller" {
      [Expiry Path Unit] #palegreen
      [Expiry Timer Unit] #palegreen
      [Expiry Service Unit] #palegreen
      [ACME Client Path Unit] #palegreen
      [ACME Client Service Unit] #palegreen

      [Principal Git Repository] <.. [Expiry Path Unit] : observe
      [Expiry Path Unit] --> [Expiry Service Unit] : run
      [Expiry Timer Unit] --> [Expiry Service Unit] : run
      [Expiry Service Unit] --> [Expiry Status File] : create\ndelete
      [CSR File] <.. [ACME Client Path Unit] : observe
      [Expiry Status File] <.. [ACME Client Path Unit] : observe
      [ACME Client Path Unit] --> [ACME Client Service Unit] : run
      [Principal Git Repository] <-- [ACME Client Service Unit] : commit

      [Push Path Unit] #lavender
      [Push Service Unit] #lavender

      [Principal Git Repository] <.. [Push Path Unit] : observe
      [Push Path Unit] --> [Push Service Unit] : run
      [Principal Git Repository] <-- [Push Service Unit] : push
   }

   node "TLS Server" {
      [Export Path Unit] #palegreen
      [Export Service Unit] #palegreen
      [Reload Path Unit] #palegreen
      [Reload Service Unit] #palegreen

      [Local Git Repository] <.. [Export Path Unit] : observe
      [Export Path Unit] --> [Export Service Unit] : run
      [Export Service Unit] --> [Local Certificate Directory] : update cert
      [Local Certificate Directory] <.. [Reload Path Unit] : observe cert
      [Reload Path Unit] --> [Reload Service Unit] : run
   }

   [Principal Git Repository] -> [Local Git Repository]


Controller node setup process
-----------------------------

In a typical certhub setup there is only **one** *Controller* node. Setting up
the *Controller* isn't something which is repeated frequently.

In order to setup a new *Controller* node, the following steps are required.
For production deployments it is recommended to use a configuration management
system.

On the *Controller* node:

1. Install required software including certhub and its dependencies. Also
   install one of the supported *ACME client*.
2. Setup the local unprivileged certhub user account.
3. Generate an SSH keypair to be used for repository replication.
4. Initialize the *Principal Git Repository*.
5. Create the necessary directory structure including private directory for
   *ACME Account Keys* as well as config and state directories.
6. Create or restore the *ACME Account Keys* for the installed *ACME Client*.


TLS Server node setup process
-----------------------------

In a typical certhub setup there are more than one *TLS Server* node. Depending
on the environment, *TLS Server* nodes might get deployed regularely.

In order to setup a new *TLS Server* node, the following steps are required.
For production deployments it is recommended to use a configuration management
system.

On the *TLS Server* node:

1. Install required software including certhub and its dependencies. Do **not**
   install any *ACME client* software on *TLS Server* nodes.
2. Setup the local unprivileged certhub user account.
3. Initialize the *Local Git Repository* and create the *Local Certificate
   Directory*.
4. Authorize the certhub user on the *Controller* node to push to the *Local
   Git Repository*.

On the *Controller* node:

1. Setup systemd units responsible for replicating the *Principal Git
   Repository* to the *Local Git Repository* on the new *TLS Server*.

.. uml::

   |TLS Server|
   start
   :Install Software;
   :Setup User;
   :Initialize Repository;
   :Authorize Controller;
   note left: Setup SSH Public\nKey Authentication
   |Controller|
   :Setup Systemd Units;
   stop


TLS Service setup process
-------------------------

In a typical certhub setup there are more than one *TLS Service*. Depending on
the environment, *TLS Services* might get deployed regularely.

The following steps are needed to create a new certificate for a new *TLS
Service*. For production deployments it is recommended to use a configuration
management system.

On the *TLS Server* node:

1. Generate a new *TLS Private Key* and *Certificate Signing Request* (*CSCR*).
2. Add a configuration file which specifies the *TLS Service(s)* to be reloaded
   whenever the certificate changes in the *Local certificate Directory*.
3. Setup systemd units responsible for exporting changed certificates and
   reloading services.

On the *Controller* node:

1. Add the newly generated *CSR* along with *ACME Client* specific
   configuration to the certhub config directory.
2. Setup systemd units responsible for checking certificate expiry and
   automatic renewal.

.. uml::

   |TLS Server|
   start
   :Generate TLS\nPrivate Key and CSR;
   :Configure Service Reload;
   :Setup Systemd Units;
   |Controller|
   :Configure ACME Client;
   :Setup Systemd Units;
   stop
