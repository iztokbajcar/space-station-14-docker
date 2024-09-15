source ./.env

CONF_PATH=$DATA_PATH/conf

# ensure that the target directory exists
mkdir -p $DATA_PATH
mkdir -p $DATA_PATH/data
mkdir -p $DATA_PATH/logs
mkdir -p $DATA_PATH/replays
mkdir -p $CONF_PATH

# copy the sample config into the data folder
cp ./server_config.toml.example $CONF_PATH/server_config.toml &&

read -p "You may now customize $CONF_PATH/server_config.toml. Press ENTER to exit."
