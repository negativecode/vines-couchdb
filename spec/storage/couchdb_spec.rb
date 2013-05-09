require 'spec_helper'

describe Vines::Storage::CouchDB do
  include StorageSpecs

  URL = 'http://localhost:5984/xmpp_testcase'.freeze

  before do
    fibered do
      database(:put)
      save_doc({'_id' => 'user:empty@wonderland.lit'})

      save_doc({
        '_id'  => 'user:no_password@wonderland.lit',
        'type' => 'User',
        'foo'  => 'bar'})

      save_doc({
        '_id'      => 'user:clear_password@wonderland.lit',
        'type'     => 'User',
        'password' => 'secret'})

      save_doc({
        '_id'      => 'user:bcrypt_password@wonderland.lit',
        'type'     => 'User',
        'password' => BCrypt::Password.create('secret')})

      save_doc({
        '_id'      => 'user:full@wonderland.lit',
        'type'     => 'User',
        'password' => BCrypt::Password.create('secret'),
        'name'     => 'Tester',
        'roster'   => {
          'contact1@wonderland.lit' => {
            'name'   => 'Contact1',
            'groups' => %w[Group1 Group2]
          },
          'contact2@wonderland.lit' => {
            'name'   => 'Contact2',
            'groups' => %w[Group3 Group4]
          }
        }
      })

      save_doc({
        '_id'  => 'vcard:full@wonderland.lit',
        'type' => 'Vcard',
        'card' => vcard.to_xml
      })

      save_doc({
        '_id'  => "fragment:full@wonderland.lit:#{fragment_id}",
        'type' => 'Fragment',
        'xml'  => fragment.to_xml
      })
    end
  end

  after do
    fibered do
      database(:delete)
    end
  end

  def save_doc(doc)
    fiber = Fiber.current
    http = EM::HttpRequest.new(URL).post(
      head: {'Content-Type' => 'application/json'},
      body: doc.to_json)
    http.callback { fiber.resume }
    http.errback { raise 'save_doc failed' }
    Fiber.yield
  end

  def database(method=:put)
    fiber = Fiber.current
    http = EM::HttpRequest.new(URL).send(method)
    http.callback { fiber.resume }
    http.errback { raise "#{method} database failed" }
    Fiber.yield
  end

  def storage
    Vines::Storage::CouchDB.new do
      host 'localhost'
      port 5984
      database 'xmpp_testcase'
    end
  end

  describe 'creating a new instance' do
    it 'raises with no host' do
      fibered do
        -> { Vines::Storage::CouchDB.new {} }.must_raise RuntimeError
      end
    end

    it 'raises with no port' do
      fibered do
        -> { Vines::Storage::CouchDB.new { host 'localhost' } }.must_raise RuntimeError
      end
    end

    it 'does not raise when given all args' do
      fibered do
        obj =
          Vines::Storage::CouchDB.new do
            host 'localhost'
            port '5984'
            database 'test'
          end
        obj.wont_be_nil
      end
    end
  end
end
