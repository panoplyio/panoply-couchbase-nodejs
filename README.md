# Couchbase NodeJS SDK Wrapper
This is a thin and simple wrapper around the Couchbase SDK for NodeJS.
On linux machines it will run a pre-install script to compile a separate version of libcouchbase with SSL support (which has been disabled in the default couchbase package)
then install the default package with the `--couchbase-root` argument set to the correct location so that the bindings compile correctly.
