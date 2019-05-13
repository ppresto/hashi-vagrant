#!/bin/bash

zypper addrepo 'https://updates.suse.com/SUSE/Products/SLE-SERVER/12-SP1/x86_64/product_source?kJaagdCknDv4MiAcRRyXyZ0p5-EM8SzaXswOfR4yjgJJ5yzSS_b2HTxLX3xcF97JmN0UDzVvkg5DKgc9Oc8ACGfRxWSQwry1ydSPXeLnvz0DQVPlVKBc_NHzWKiJZ6yIwJIhVokxFx2iIwzxwzsOCEeZ0bU' 'SLES12-SP1-Source-Pool'
zypper addrepo 'https://updates.suse.com/SUSE/Updates/SLE-SERVER/12-SP1/x86_64/update?6dvcsuOSVjOIPIa4YUARThcAsGtaSAuZq6gH6oOTXaEqMnnJ4kEYmkhlT3Hu0Z4jV_fCz8ucrq_Nk-xXa9HahEBSgyXHi1vvC-YrMazIbZwtdvdAfIEakxZO_gcrNGh5z4qbCY_gYdj3XeA' 'SLES12-SP1-Updates'
zypper addrepo 'https://updates.suse.com/SUSE/Products/SLE-SERVER/12-SP1/x86_64/product?A31MDrt5jeg2Zz1IfnK4xrKCiFoTWpLnTx7txiKxFQRJ10QQ56_jAF2pRV4PXwMrsg2My8qZv3sng1Q-paOox7QqLIMbgEMB-vOlOwrlfTZqR4KVcuoFuFimxqUXhGJrvKGVxEtJ_jmgLEIybQ' 'SLES12-SP1-Pool'
zypper addrepo 'https://updates.suse.com/SUSE/Products/SLE-SERVER/12-SP1/x86_64/product_debug?EjiovPt9lWvY322GitJnYN2LHDx9HlEWamNxdcDqCVDh8U5ZqJV3qdzBks2XEDjXq74OPFPf_TucdC5ewOjM0zrvAGESglwDYWrww-6wh5jfMgQAeAherF6lpbMWtwGion2-skC7Ma-n_tzmtSFjnCgb5w' 'SLES12-SP1-Debuginfo-Pool'
zypper addrepo 'https://updates.suse.com/SUSE/Updates/SLE-SERVER/12-SP1/x86_64/update_debug?BK_OOMyFmM4R9onIcxAz1ReIXfhSsSZf0vM0duDKPVY0mRCYG4zukuq-xP8CvSXFS7kJXUaV3l-WGX8bDMEp0ZrleWEp4CypOHxWu21EPQBKhas_14dJZ-nFP8ZrLxT08KcFr3z3GdQM1hqeQbxYYD4' 'SLES12-SP1-Debuginfo-Updates'
zypper refresh

SRCRPMS="libmcrypt tidy"

if ! zypper lr | grep -q SDK; then
  zypper addrepo 'https://updates.suse.com/SUSE/Products/SLE-SDK/12-SP1/x86_64/product_debug?kqVKvgAAAAAAAAAApAuyt6ULsENKN0jzxxea14vb_fRUgpcvsMCrTIMtVPFzfn89pIqr_qOYAVhwgOhrmY6dxB046uQPLEr2fECgjijwi1ql1Pt0ioTnRWjAfvNXs4HU-EKsbdYvt76Kcg3r6YLEMA' 'SLE-SDK12-SP1-Debuginfo-Pool'
  zypper addrepo 'https://updates.suse.com/SUSE/Updates/SLE-SDK/12-SP1/x86_64/update_debug?wH034A7Dw0J-CrkNKjmMrTwjfYoHTc0wtcV34fdJQ8lZL6WluJzzz6SL4x1wj7X6EaAwK6qyHlIwqbX12dQBMAb3qR82kusC13PZeIQ8uMJw8UFgrhmSb3XZ2lcwMNaEs-QuSrb240JXwB1yoz8' 'SLE-SDK12-SP1-Debuginfo-Updates'
  zypper addrepo 'https://updates.suse.com/SUSE/Products/SLE-SDK/12-SP1/x86_64/product?YjLbOm0voWFvCGx6rjvPEiEWD2-iVsDc3UnShaMFt6jbGZHqWSbvflZBJ0Z-IdR50K1igr5MqKzK7YmzxuyPl8O54wbPf4lQO7C5uvCWB1Yx6OZykdWHjfHPQPvgu04hyj-vDnTxyxdPSA' 'SLE-SDK12-SP1-Pool'
  zypper addrepo 'https://updates.suse.com/SUSE/Products/SLE-SDK/12-SP1/x86_64/product_source?DslHOudrX_DR8kZha27QmX-e5mFvsPSrFLQE7ZckPdY2CH2RvtnaCQiVv69aFmpUcjzq7m5RbqJ9UVXcqXx_32LJ-2dSawTnWFzcEbpHZUDHpSmLP2_nOy3COdnNDdiH9XBXGlR_BfOWc03b7iDOHFM' 'SLE-SDK12-SP1-Source-Pool'
  zypper addrepo 'https://updates.suse.com/SUSE/Updates/SLE-SDK/12-SP1/x86_64/update?UqJCfWamuu7AKtu_LCK5WwDb6TjhsTMvA51K-n_37oQMWVPIl5QC0xcdAkgIDHsIHbKLh0D9FcPjtMfo5u8kb5om4KPZjoBlkmh1OBOpQ3qcExvsxAmsO2CLocdA9Pj7OrKwQkjZWQI' 'SLE-SDK12-SP1-Updates'
  zypper refresh
fi

for srcrpm in $SRCRPMS; do
  if ! rpm -qa | grep -q $srcrpm; then
    zypper --quiet --non-interactive si $srcrpm
    cd /usr/src/packages/SPECS
    rpmbuild --quiet -bb ${srcrpm}.spec 2>&1 >/dev/null
    zypper --quiet --non-interactive install /usr/src/packages/RPMS/x86_64/*${srcrpm}*.rpm
  fi
done

zypper --quiet --non-interactive install --no-recommends \
  ImageMagick-devel \
  freetype-devel \
  freetype2-devel \
  libXpm-devel \
  libbz2-devel \
  libcurl-devel \
  libicu-devel \
  libjpeg8-devel \
  libmjpegutils-devel \
  libopenssl-devel \
  libpng16-devel \
  libtidyp-devel \
  libvpx-devel \
  libxml2-devel \
  libxslt-devel \
  libzio-devel \
  libzip-devel \
  lua51-devel \
  mozilla-nss-devel \
  pcre-devel \
  rpm-build \
  zlib-devel
