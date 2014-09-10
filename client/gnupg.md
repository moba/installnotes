# GnuPG Notes

## temporarily change keystore location

Useful for testing and for offline keys. Use Live CD for offline keys!

    export GNUPGHOME=/save/location

## some default preferences

    cat >>~/.gnupg/gpg.conf <<EOF
    no-version
    personal-digest-preferences SHA512
    cert-digest-algo SHA512
    default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
    ask-cert-level
    cert-policy-url http://www.headstrong.de/keysigning-policy
    EOF

  * hashing algorithms
  * disable version display
  * set default policy url for signing

## key generation

My recommendation: 

    gpg --expert --gen-key # for master key
    KEYID=ABCDABCD
    gpg --expert --edit-key $KEYID
    gpg> addkey # repeat for all subkeys
    gpg> quit
    gpg --output $KEYID-revocation-cert.gpg --gen-revoke $KEYID
    gpg --quiet --batch --yes --output $KEYID-secret-subkeys.gpg --export-secret-subkeys $KEYID
    gpg --quiet --batch --yes --output $KEYID-secret-master-key.gpg --export-secret-keys $KEYID
    gpg --quiet --batch --yes --output $KEYID-public.gpg --export $KEYID

  * master key: capability certify ( = for signing keys)
  * separate subkeys for each other capability
  * set an expiration date on the master key and the subkeys. remind yourself to rotate subkeys and move the master key expiration date before it expires. i find 6 months to 1 year a reasonable span.


## regular keyring: import only subkeys

    gpg --import $KEYID-public.gpg $KEYID-secret-subkeys.gpg

## when signing, specify signing policy

    gpg --ask-cert-level --cert-policy-url http://www.headstrong.de/keysigning-policy --sign-key ABCDABCD

## key transition statement

example: http://gagravarr.org/key-transition-2009-05-06.txt

## RSA 8192 bit keys

You don't really ever need a larger key than 4096. If there's serious advances in breaking 2048+ bit RSA keys, they will go against all keysizes.

GnuPG no longer allows you to create larger keys. In previous versions, the batch mode allowed keys up to 8192 bit:

    gpg --batch --gen-key <<EOF
    Key-Type: RSA
    Key-Length: 8192
    Key-Usage: cert
    Name-Real: ME
    Name-Email: EMAIL
    Passphrase: PASSWORD
    EOF

## Smartcard

  * Reader: https://shop.kernelconcepts.de/product_info.php?products_id=119
    * use reader with PIN-pad for additional security
  
  * Javacard: Open Source Java Applets available (running on closed source OS)
    * can't find any cards that support keys larger than 2048
    * https://subgraph.com/cards/
    * http://smartcardsource.com/
    * https://www.fi.muni.cz/~xsvenda/jcsupport.html

  * Basiccard: Closed Source
    * developers have to sign NDA -> no open source?
    * G10Code (Werner Koch) Smartcard: https://shop.kernelconcepts.de/product_info.php?products_id=42
    * supports 4096 bit keys (Smartcard v2, GnuPG >= 2.0.18)
    * https://shop.kernelconcepts.de/product_info.php?products_id=42

### Install

    sudo apt-get install pcscd gpgsm

### Init

    gpg --card-status
    gpg --change-pin
    gpg --card-edit

### Generate Subkeys on Smartcard

You don't actually want to do that because you will not have backup, except maybe for authentication subkeys.

    gpg --edit-key $KEYID
    gpg> addcardkey

### Move Subkeys to Smartcard

Make a local copy first, as subkey will be transferred to the card and the local copy rendered unusable.

    gpg -a --export-secret-keys $KEYID > $KEYID.key.asc

    gpg --edit-key $KEYID
    gpg> toggle
    gpg> key 1 # select encryption subkey
    gpg> keytocard
    gpg> key 2 # select signature subkey
    gpg> keytocard
    ...
    gpg> save

### Authenticate to a SSH server with GPG Smartcard

Make a Authentication Subkey on the Smartcard

    gpg --edit-key $KEYID
    gpg> addcardkey
    
Then choose option 3. Enter passphrase and key when queried.

Put the following in a text file, make sure it is run everytime your
Desktop environment or window manager starts up:

    #!/bin/sh
    gpg-agent --daemon --enable-ssh-support > ~/.gnupg/gpg-agent.env
    source ~/.gpg-agent.env
    
Log out of and into your Desktop environment.

Check if it is working

    ssh-add -l
    
Copy the public key over to the server

    gpgkey2ssh $AUTHSUBKEY > authorized_keys
    scp authorized_keys user@server:~/.ssh/authorized_keys

Or, alternatively, use ssh-copyid 

    ssh-copyid user@server
    
Now when you ssh into this box ssh should ask for your PIN instead of your passphrase.

# References

http://gagravarr.livejournal.com/137173.html

https://www.apache.org/dev/openpgp.html

http://www.eharning.us/gpg/

http://www.narf.ssji.net/~shtrom/wiki/tips/openpgpsmartcard
