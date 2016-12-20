PROJECT = emq_hook
PROJECT_DESCRIPTION = EMQ Plugin Template
PROJECT_VERSION = 2.0.1

DEPS = eredis brod
dep_eredis = git https://github.com/wooga/eredis master
#dep_ekaf = git https://github.com/helpshift/ekaf master
dep_brod = git https://github.com/klarna/brod master

BUILD_DEPS = emqttd
dep_emqttd = git https://github.com/wuhanqing/emqttd develop

TEST_DEPS = cuttlefish
dep_cuttlefish = git https://github.com/emqtt/cuttlefish

COVER = true

include erlang.mk

app:: rebar.config

app.config::
	cuttlefish -l info -e etc/ -c etc/emq_hook.conf -i priv/emq_hook.schema -d data
