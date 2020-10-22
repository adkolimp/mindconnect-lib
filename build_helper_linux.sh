#!/bin/bash
openssl_version=1.1.1d
curl_version=7.65.3
main_directory=../mcl_sandbox
mcl_directory=$(pwd)

mkdir $main_directory
cd $main_directory

#Change relative path to absolute.
main_directory=$(pwd)

wget -c https://www.openssl.org/source/openssl-$openssl_version.tar.gz
tar -xvzf openssl-$openssl_version.tar.gz

wget https://curl.haxx.se/download/curl-$curl_version.tar.gz
tar -xvzf curl-$curl_version.tar.gz

cd openssl-$openssl_version
./config --prefix=$main_directory/install -Wl,-rpath=$main_directory/install/lib shared -fPIC && make install_sw
cd ..

cd curl-$curl_version
LDFLAGS="-Wl,-R$main_directory/install/lib" ./configure --enable-http --with-ssl=$main_directory/install --prefix=$main_directory/install --without-libssh2 --disable-ftp --disable-tftp --disable-file --disable-ldap --disable-rtsp --disable-dict --disable-telnet --disable-pop3 --disable-imap --disable-smb --disable-scp --disable-sftp --disable-smtp --disable-gopher --disable-manual && make install
cd ..

mkdir mcl_build
cd mcl_build
cmake -DCMAKE_PREFIX_PATH="$main_directory/install" -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX:PATH=$main_directory/install -DMCL_STATICLIB=OFF -DMCL_LOG_LEVEL=MCL_LOG_LEVEL_NONE $mcl_directory
cmake --build . --clean-first --target install
