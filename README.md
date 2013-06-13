# Welcome to Vines

Vines is a scalable XMPP chat server, using EventMachine for asynchronous IO.
This gem provides support for storing user data in
[Apache CouchDB](https://couchdb.apache.org/).

Additional documentation can be found at [getvines.org](http://www.getvines.org/).

## Usage

```
$ gem install vines vines-couchdb
$ vines init wonderland.lit
$ cd wonderland.lit && vines start
```

## Configuration

Add the following configuration block to a virtual host definition in
the server's `conf/config.rb` file.

```ruby
storage 'couchdb' do
  host 'localhost'
  port 6984
  database 'xmpp'
  tls true
  username ''
  password ''
end
```

## Dependencies

Vines requires Ruby 1.9.3 or better. Instructions for installing the
needed OS packages, as well as Ruby itself, are available at
[getvines.org/ruby](http://www.getvines.org/ruby).

## Development

```
$ script/bootstrap
$ script/tests
```

## Contact

* David Graham <david@negativecode.com>

## License

Vines is released under the MIT license. Check the LICENSE file for details.
