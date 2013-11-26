# GnuPG Notes

http://gagravarr.livejournal.com/137173.html

https://www.apache.org/dev/openpgp.html

http://www.eharning.us/gpg/

http://www.narf.ssji.net/~shtrom/wiki/tips/openpgpsmartcard

## temporarily change keystore location

Useful for testing and for offline keys. Use Live CD for offline keys!

    export GNUPGHOME=/save/location

## RSA 8192 bit keys

For a 8192 bit master key, you can use GnuPG batch mode.

    gpg --batch --gen-key <<EOF
    Key-Type: RSA
    Key-Length: 8192
    Key-Usage: cert
    Name-Real: ME
    Name-Email: EMAIL
    Passphrase: PASSWORD
    EOF

If you also want to generate 8192 bit subkeys, you need to modify the GnuPG source.

    sudo apt-get build-dep gnupg
    apt-get source gnupg
    cd gnupg-*
    vi g10/keygen.c
    # search 4096, replace 8192
    dpkg-buildpackage -us -uc -nc
    cd ..
    dpkg -i gnupg_*.deb

## some default preferences

 * hashing algorithms
 * disable version display
 * set default policy url for signing

    cat >>~/.gnupg/gpg.conf <<EOF
    no-version
    personal-digest-preferences SHA512
    cert-digest-algo SHA512
    default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
    ask-cert-level
    cert-policy-url http://www.headstrong.de/keysigning-policy
    EOF

## key generation

    gpg --gen-key # for master key
    KEYID=ABCDABCD
    gpg --edit-key $KEYID
    gpg> addkey # repeat for all subkeys
    gpg> quit
    gpg --output $KEYID-revocation-cert.gpg --gen-revoke $KEYID
    gpg --quiet --batch --yes --output $KEYID-secret-subkeys.gpg --export-secret-subkeys $KEYID
    gpg --quiet --batch --yes --output $KEYID-secret-master-key.gpg --export-secret-keys $KEYID
    gpg --quiet --batch --yes --output $KEYID-public.gpg --export $KEYID

## regular keyring: import only subkeys

    gpg --import $KEYID-public.gpg $KEYID-secret-subkeys.gpg

## when signing, specify signing policy

    gpg --ask-cert-level --cert-policy-url http://www.headstrong.de/keysigning-policy --sign-key ABCDABCD

## key transition statement

example: http://gagravarr.org/key-transition-2009-05-06.txt

## Smartcard

### Install

    sudo apt-get install pcscd gpgsm

### Init

    gpg --card-status
    gpg --change-pin
    gpg --card-edit

### Generate Subkeys on Smartcard

    gpg --edit-key $KEYID
    gpg> addcardkey

### Move Subkeys to Smartcard

Make a local copy first, as subkey will be transferred to the card and the local copy rendered unusable.

    gpg -a --export-secret-keys $KEYID > $KEYID.key.asc

    gpg --edit-key $KEYID
    gpg> keytocard

### Authenticate to a SSH server with GPG Smartcard

Make a Authentication Subkey on the Smartcard

    gpg --edit-key $KEYID
    gpg> addcardkey
    
Then choose option 3. Enter passphrase and key when queried.

Put the following in a text file, make sure it is run everytime your
Desktop environment or window manager starts up:

    #!/bin/sh
    gpg-agent --daemon --enable-ssh-support > ~/.gpgssh.env
    . ~/.gpgssh.env
    
Log out of and into your Desktop environment.

Copy the Public key over to the server

    gpgkey2ssh $AUTHSUBKEY > authorized_keys
    scp authorized_keys testuser@testserver.tld:~/.ssh/authorized_keys
    
Now everytime you ssh into this box ssh should ask for your PIN instead of your passphrase.
