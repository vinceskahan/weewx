

#-------------------------------------------
#
# simple example of how to resign rpms
#
# both --addsign and --resign seem to work
#
# this first resigns as needed
# and then queries the rpms for their
# signature keys
#
#-------------------------------------------

REPODIR="/root/repos"
for repo in el7 el8
do
  echo "........ resigning ${repo} ........"
  rpm --addsign ${REPODIR}/${repo}/RPMS/*.rpm
done

for repo in el7 el8
do
  echo "........ checking ${repo} ........"
  rpm -qi       ${REPODIR}/${repo}/RPMS/*.rpm | grep Sig
done
