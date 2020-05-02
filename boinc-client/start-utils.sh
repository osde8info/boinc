cfg_ram_max_busy_xml_key='ram_max_used_busy_pct'
cfg_ram_max_idle_xml_key='ram_max_used_idle_pct'
threshold_ram_settings_pct=95

get_int_xml_val() {
  local xml_val=$(xml_grep --text_only "$1" "$2")
  local xml_int_val=$(awk "BEGIN {print int($xml_val)}")
  echo $xml_int_val
}

account_project_enable() {
  sed -i -e "s|<$1>[0-9a-z_]\{1,\}</$1>|<$1>$2</$1>|g" "accounts/$3"
  cp "accounts/$3" ./boinc
}

update_float_xml_val_with_int() {
  sed -i -e "s|<$1>[0-9a-z.]\{1,\}</$1>|<$1>$2.000000</$1>|g" "$3"
}

validate_ram_settings() {
  local cfg_ram_max_busy=$(get_int_xml_val "$cfg_ram_max_busy_xml_key" "$prefs_file_path")
  local cfg_ram_max_idle=$(get_int_xml_val "$cfg_ram_max_busy_xml_key" "$prefs_file_path")

  echo "Validating boinc RAM settings"

  if [[ ! -z $cfg_ram_max_busy && $cfg_ram_max_busy -gt $threshold_ram_settings_pct ]]; then
    echo "  max RAM when busy (${cfg_ram_max_busy}%) too high - setting to ${threshold_ram_settings_pct}%"
    update_float_xml_val_with_int "$cfg_ram_max_busy_xml_key" "$threshold_ram_settings_pct" "$prefs_file_path"
  fi

  if [[ ! -z $cfg_ram_max_idle && $cfg_ram_max_idle -gt $threshold_ram_settings_pct ]]; then
    echo "  max RAM when idle (${cfg_ram_max_idle}%) too high - setting to ${threshold_ram_settings_pct}%"
    update_float_xml_val_with_int "$cfg_ram_max_idle_xml_key" "$threshold_ram_settings_pct" "$prefs_file_path"
  fi
}
