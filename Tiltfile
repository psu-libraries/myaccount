load('ext://git_resource', 'git_checkout')
load('ext://namespace', 'namespace_create', 'namespace_inject')
load('ext://helm_resource', 'helm_resource', 'helm_repo')
load('ext://syncback', 'syncback')

user = os.getenv('USER', default='robot')
namespace = "myaccount-%s" % (user)

namespace_create(namespace)

docker_build('harbor.k8s.libraries.psu.edu/library/myaccount', '.', target='test', live_update=[
  sync('.', '/app')
])

git_checkout('git@github.com:psu-libraries/myaccount-config', '.repos/myaccount-config')

# install myaccount
yaml = helm('.repos/myaccount-config/charts/myaccount', 
  name='myaccount',
  namespace=namespace,
  values='config/helm-values.yaml',
  )

k8s_yaml(namespace_inject(yaml, namespace))

k8s_resource(workload='myaccount', port_forwards=3000)

syncback('syncback', 'deploy/myaccount',
         '/app/', ignore=['vendor', 'node_modules', 'tmp', '.cache', '.repos', 'config/settings.local.yml'],
         target_dir='.'
)

