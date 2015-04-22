Package.describe({
  name: 'meteorspark:test-helpers',
  summary: 'A collection of helpers for Meteor TinyTest based unittesting',
  version: '0.2.0',
  git: 'https://github.com/MeteorSpark/test-helpers'
});

both = ['server', 'client'];
server = 'server';
client = 'client';

Package.onUse(function (api) {
  api.versionsFrom('0.9.4');

  api.use('coffeescript', both);
  api.use('underscore', both);
  api.use('meteor', both);

  api.use('accounts-base', both);
  api.use('accounts-password', both);

  api.add_files('lib/both.coffee', server);
  api.add_files('lib/both.coffee', client, {bare: true});

  api.export('TestHelpers');
});
