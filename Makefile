PROJECT = emq_plugin_hook
PROJECT_DESCRIPTION = EMQ Plugin Template
PROJECT_VERSION = 2.0.1

BUILD_DEPS = emqttd lager
dep_emqttd = git https://github.com/emqtt/emqttd master
dep_lager  = git https://github.com/basho/lager master

TEST_DEPS = cuttlefish
dep_cuttlefish = git https://github.com/emqtt/cuttlefish

COVER = true

include erlang.mk

app:: rebar.config

app.config::
	cuttlefish -l info -e etc/ -c etc/emq_plugin_hook.conf -i priv/emq_plugin_hook.schema -d data
