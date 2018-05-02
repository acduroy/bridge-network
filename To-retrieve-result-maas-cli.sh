# This script will retrieve the result from MAAS CLI commands
# ref: https://docs.maas.io/devel/en/manage-cli-common#determine-a-node's-system-id
# In this case, the $PROFILE is "admin" and $HOSTNAME is "RU5-smartctl"

# First, list all nodes in MAAS. In this case the $PROFILE is admin
maas $PROFILE nodes read |grep hostname
maas admin nodes read |grep hostname

#Sample output from screen:
# "hostname": "RU4",
#        "hostname": "RU5-smartctl",
#        "hostname": "vast-quail-LTS",
#        "hostname": "maas209",


# Determine a node system ID thru hostname  
maas $PROFILE nodes read hostname=$HOSTNAME | grep system_id -m 1 | cut -d '"' -f 4
maas admin nodes read hostname=RU5-smartctl | grep system_id -m 1 | cut -d '"' -f 4 

#Sample system_id output is "bdx6np"

# To retrieve current testing result. 
# Other results can also be retrieved using; current-commissioning, current-installation  
maas admin node-script-result read bdx6np  current-testing | tee current-testing.txt

# To download the current test result file
maas admin node-script-result download bdx6np  current-testing  output=all filetype=tar.xz > current-test




 
