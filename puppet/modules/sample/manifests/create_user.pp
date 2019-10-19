class sample::create_user (
$user_name,
$user_id,
) {

user { "$user_name":
  ensure => present,
  uid    => "$user_id",
  home   => "/home/$user_name",
  shell  => '/bin/bash',
}

}
