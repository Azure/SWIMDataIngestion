default['kafkaServer']['kafkaRepo'] = 'https://archive.apache.org/dist/kafka/'
default['kafkaServer']['kafkaVersion'] = '2.3.0'
default['kafkaServer']['solaceCoonector'] = '2.1.0'

# TFMS configuration
default['kafkaServer']['SWIMEndpointPort'] = 55443
default['kafkaServer']['SWIMVPN'] = 'TFMS'

## TFMS Secrets moved to a data bag
# default['kafkaServer']['SWIMEndpoint']=''
# default['kafkaServer']['SWIMUserNaMe']=''
# default['kafkaServer']['Password']=''
# default['kafkaServer']['SWIMQueue']=''
