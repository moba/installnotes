# GnuPG Notes

http://gagravarr.livejournal.com/137173.html

https://www.apache.org/dev/openpgp.html

http://www.eharning.us/gpg/

## RSA 8192 bit keys

For a 8192 bit master key, you can use GnuPG batch mode.

    gpg --batch --gen-key <<EOF
    Key-Type: RSA
    Key-Length: 8192
    Key-Usage: auth
    Name-Real: ME
    Name-Comment: COMMENT
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

## temporarily change keystore location

Useful for testing and for offline keys. Use Live CD for offline keys!

    export GNUPGHOME=/save/location

## key generation

    gpg --gen-key # for master key
    FINGERPRINT=ABCDABCD
    gpg --edit-key $FINGERPRINT
    gpg> addkey # repeat for all subkeys
    gpg> quit
    gpg --output $FINGERPRINT-revocation-cert.gpg --gen-revoke $FINGPERPRINT
    gpg --quiet --batch --yes --output $FINGERPRINT-secret-subkeys.gpg --export-secret-subkeys $FINGERPRINT
    gpg --quiet --batch --yes --output $FINGERPRINT-secret-master-key.gpg --export-secret-keys $FINGERPRINT
    gpg --quiet --batch --yes --output $FINGERPRINT-public.gpg --export $FINGERPRINT

## regular keyring: import only subkeys

    gpg --import $FINGERPRINT-public.gpg $FINGERPRINT-secret-subkeys.gpg

## when signing, specify signing policy

    gpg --ask-cert-level --cert-policy-url http://www.headstrong.de/keysigning-policy --sign-key ABCDABCD

## key transition statement

example: http://gagravarr.org/key-transition-2009-05-06.txt
