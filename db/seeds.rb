# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless Template.where(name: 'Wordpress').present?
  wp = Template.create(
    name: 'Wordpress',
    description: 'This is a wordpress template',
    recommended: true,
    icon: 'http://panamax.ca.tier3.io/template_logos/wordpress.png',
    documentation: "# Wordpress\r\nThis is a WordPress template based on the [panamax/panamax-docker-wordpress](https://index.docker.io/u/panamax/panamax-docker-wordpress/) and [panamax/panamax-docker-mysql](https://index.docker.io/u/panamax/panamax-docker-mysql/) images.\r\nThe template exposes port 80 in the container to port 8080 on the Docker host.  In order to view the WordPress admin console after running the template, ensure that the virtual machine serving as the Docker host is forwarding a port to port 8080 on the host."
  )
  web_cat = TemplateCategory.create(
    name: 'Web Tier',
    template: wp
  )
  db_cat = TemplateCategory.create(
    name: 'DB Tier',
    template: wp
  )
  wp.images.create(
    name: 'DB_1',
    repository: 'panamax/panamax-docker-mysql',
    tag: 'latest',
    description: 'MySQL',
    expose: [3306],
    environment: { 'MYSQL_ROOT_PASSWORD' => 'pass@word01'},
    ports: [{host_port: 3306, container_port: 3306}],
    categories: [db_cat],
    icon: 'http://panamax.ca.tier3.io/service_icons/icon_service_db_grey.png'
  )
  wp.images.create(
      name: 'WP',
      repository: 'panamax/panamax-docker-wordpress',
      tag: 'latest',
      description: 'Wordpress',
      links: [{service: 'DB_1', alias:'DB_1'}],
      ports: [{host_port: 8080, container_port: 80}],
      expose: [80],
      environment: { 'DB_PASSWORD' => 'pass@word01' },
      categories: [web_cat],
      icon: 'http://panamax.ca.tier3.io/service_icons/icon_service_wp_grey.png'
  )
end

unless Template.where(name: 'Rails').present?
  rails = Template.create(
      name: 'Rails',
      description: 'This is a Rails app template',
      recommended: true,
      icon: 'http://panamax.ca.tier3.io/template_logos/default.png'

  )
  rails.images.create(
      name: 'DB_2',
      repository: 'dharmamike/dc-pgsql',
      tag: 'latest',
      description: 'PostgreSQL',
      ports: [{host_port: 5432, container_port: 5432}],
      icon: 'http://panamax.ca.tier3.io/service_icons/icon_service_db_grey.png'
  )
  rails.images.create(
    name: 'APP',
    repository: 'dharmamike/dc-rails',
    tag: 'latest',
    description: 'welcome to rails',
    links: [{service: 'DB_2', alias:'DB_1'}],
    ports: [{host_port: 8088, container_port: 3000}],
    icon: 'http://panamax.ca.tier3.io/service_icons/icon_service_docker_grey.png'

  )
end

unless Template.where(name: 'Apache')
  Template.create(
    name: 'Apache',
    description: 'This is a recommended apache template',
    recommended: false,

  )
end
