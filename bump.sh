#!/bin/bash
ed -s `gr -l VERSION lib/` <<END
/VERSION
s/$1/$2/
wq
END
