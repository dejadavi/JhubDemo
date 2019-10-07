#!/usr/bin/env bash

set -euf -o pipefail

aws emr create-cluster \
--applications Name=Hadoop Name=Hive Name=Hue Name=Tez Name=JupyterHub Name=Presto Name=Sqoop Name=HCatalog Name=Livy \
--ec2-attributes '{"KeyName":"somename","InstanceProfile":"EMR_EC2_DefaultRole","SubnetId":"mysubnet","EmrManagedSlaveSecurityGroup":"sg-somegroup","EmrManagedMasterSecurityGroup":"sg-somegroup"}' \
--release-label emr-5.27.0 \
--log-uri 'myloguri/elasticmapreduce/' \
--instance-groups '[{"InstanceCount":2,"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":32,"VolumeType":"gp2"},"VolumesPerInstance":2}]},"InstanceGroupType":"CORE","InstanceType":"m5.xlarge","Name":"Core Instance Group"},{"InstanceCount":1,"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":32,"VolumeType":"gp2"},"VolumesPerInstance":2}]},"InstanceGroupType":"MASTER","InstanceType":"m5.xlarge","Name":"Master Instance Group"}]' \
--configurations '[{"Classification":"emrfs-site","Properties":{"fs.s3.consistent.retryPeriodSeconds":"10","fs.s3.consistent":"true","fs.s3.consistent.retryCount":"5","fs.s3.consistent.metadata.tableName":"EmrFSMetadata"}},{"Classification":"jupyter-sparkmagic-conf","Properties":{"kernel_python_credentials":"{\"username\":\"jovyan\",\"base64_password\":\"somepassword",\"url\":\"http:\/\/localhost:8998\",\"auth\":\"None\"}"}},{"Classification":"hive-site","Properties":{"hive.metastore.client.factory.class":"com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"}},{"Classification":"presto-connector-hive","Properties":{"hive.metastore.glue.datacatalog.enabled":"true"}}]' \
--ebs-root-volume-size 10 \
--service-role EMR_DefaultRole \
--enable-debugging \
--name 'demo' \
--region us-east-1
