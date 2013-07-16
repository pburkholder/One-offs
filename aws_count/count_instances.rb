#!/usr/local/bin/ruby

require 'yaml'
require 'aws-sdk'
require 'pp'

config_file = File.join(File.dirname(__FILE__), 'config.yml')

config = YAML.load(File.read(config_file))

AWS.config(config)

c = AWS::EC2::ReservedInstancesCollection.new()



zones=('a'..'e').to_a.map{|z| "us-east-1#{z}"}

# The filter methods use filter names based on the API # docs, e.g.
# http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeReservedInstances.html
# not the Object attributes in the AWS Ruby SDK. Hence, we filter on
# 'instance-type', not 'instance_type'

zones.each do |zone|
  puts zone
  p c.member_class
  c.filter('availability-zone',zone).each { |cc|
    pp cc
    p cc.instance_count
    p cc.availability_zone
  }

end


c.filter('state', 'active').filter('instance-type', 'm1.large') \
  .each{|i| puts i.instance_count, i.availability_zone}
