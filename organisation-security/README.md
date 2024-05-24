## organisation-security

This directory holds the [Terraform](https://terraform.io) for the AWS account named "organisation-security" in MOJ's [AWS Organizations](https://aws.amazon.com/organizations/) configuration.

### IPAM BYOIP Guidance

See guidance here on how to BYOIP to AWS - https://docs.aws.amazon.com/vpc/latest/ipam/tutorials-byoip-ipam-ipv4.html

#### Managing imported ranges

Once the range has been assigned to a public IPAM pool as above, the pool can be shared to different accounts using RAM. See ipam.tf for examples.

Before IPs can be used they must be provisioned to an account IPV4 CIDR pool at the account level.

##### Create an IPV4 account level CIDR pool

In the account where you wish to use the IPs, ensure the IPAM pool has been shared to that account, then create a new IPV4 CIDR pool.

```shell
aws ec2 create-public-ipv4-pool --region eu-west-2
{
    "PoolId": "ipv4pool-ec2-xxxxx"
}

$aws ec2 describe-public-ipv4-pools
{
    "PublicIpv4Pools": [
        {
            "PoolId": "ipv4pool-ec2-xxxxx",
            "Description": "",
            "PoolAddressRanges": [],
            "TotalAddressCount": 0,
            "TotalAvailableAddressCount": 0,
            "NetworkBorderGroup": "eu-west-2",
            "Tags": []
        }
    ]
}

```

##### Provision IP CIDR range

Get the IPAM pool ID from the IPAM console, use the IPV4 pool ID from above, then provision the range you want (you do not have to provision the whole range from the IPAM pool)

```shell
aws ec2 provision-public-ipv4-pool-cidr --region eu-west-2 --ipam-pool-id ipam-pool-xxxx --pool-id ipv4pool-ec2-xxxxx --netmask-length 26
```

##### Deprovision IP CIDR range

To deprovision the range, you need to do it one IP at a time.

```
aws ec2 deprovision-public-ipv4-pool-cidr --region eu-west-2 --pool-id ipv4pool-ec2-xxxxx --cidr 51.0.0.254/32
```

To do this quickly for a whole range use a script similar to:

```
region="eu-west-2"
pool_id="ipv4pool-ec2-xxxxx"
base_cidr="51.0.0"

# Iterate through the IP range /24
for i in {0..255}
do
  ip="${base_cidr}.${i}/32"
  echo "Deprovisioning IP: $ip"
  aws ec2 deprovision-public-ipv4-pool-cidr --region $region --pool-id $pool_id --cidr $ip

  if [ $? -ne 0 ]; then
    echo "Failed to deprovision IP: $ip" >&2
    # exit 1
  fi
done
```
