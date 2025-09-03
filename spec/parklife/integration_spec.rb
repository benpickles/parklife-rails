require 'open3'

RSpec.describe 'Integration tests' do
  def command(cmd, env = {})
    env = { 'RAILS_ENV' => 'test' }.merge(env)

    Dir.chdir('example-app') do
      Open3.capture2(env, cmd)
    end
  end

  def parklife(cmd, env = {})
    command("bundle exec parklife #{cmd}", env)
  end

  it 'gives access to Rails URL helpers when defining routes' do
    stdout, status = parklife('routes')
    expect(status).to be_success
    expect(stdout).to include('/test/middleware', '/test/url')
  end

  it 'configures Rails default_url_options/relative_url_root when setting a Parklife base' do
    stdout, status = parklife('get /test/url')
    expect(status).to be_success
    expect(stdout.chomp).to eql('http://example.com/test/url')

    stdout, status = parklife('get /test/url --base /foo')
    expect(status).to be_success
    expect(stdout.chomp).to eql('http://example.com/foo/test/url')

    stdout, status = parklife('get /test/url --base https://foo.example.org/foo/bar')
    expect(status).to be_success
    expect(stdout.chomp).to eql('https://foo.example.org/foo/bar/test/url')
  end

  it "sets Parklife's base from Rails default_url_options/relative_url_root when they're defined" do
    stdout, status = parklife('get /test/url', 'PARKLIFE_SET_RAILS_URL' => 'yes')
    expect(status).to be_success
    expect(stdout.chomp).to eql('https://rails.example.org/foo/test/url')
  end

  it "updates Parklife's base with Rails force_ssl setting" do
    stdout, status = parklife('get /test/url', 'PARKLIFE_SET_RAILS_URL' => 'force_ssl')
    expect(status).to be_success
    expect(stdout.chomp).to eql('https://example.com/test/url')
  end

  it 'host authorization middleware is removed in development - but only for a Parklife request' do
    env = { 'RAILS_ENV' => 'development' }

    stdout, status = command('bundle exec rails middleware', env)
    expect(status).to be_success
    expect(stdout).to include('ActionDispatch::HostAuthorization')

    stdout, status = parklife('get /test/middleware', env)
    expect(status).to be_success
    expect(stdout).not_to include('ActionDispatch::HostAuthorization')
  end
end
