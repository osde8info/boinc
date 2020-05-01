#!/bin/bash

mkdir -p /usr/app/boinc/locale
mkdir -p /usr/app/boinc/slots

LHC_XML='accounts/account_lhcathome.cern.ch_lhcathome.xml'
UNI_XML='accounts/account_universeathome.pl_universe.xml'
YOY_XML='accounts/account_www.rechenkraft.net_yoyo.xml'

prefs_file_path='global_prefs_override.xml'
cfg_ram_max_busy_xml_key='ram_max_used_busy_pct'
cfg_ram_max_idle_xml_key='ram_max_used_idle_pct'
threshold_ram_settings_pct=95

. start-utils.sh

# remove all accounts & projects

rm boinc/account_*

if [[ $LHC_KEY ]]; then
  account_project_enable authenticator $LHC_KEY $LHC_XML
fi

if [[ $UNI_KEY ]]; then
  account_project_enable authenticator $UNI_KEY $UNI_XML
fi

if [[ $YOY_KEY ]]; then
  account_project_enable authenticator $YOY_KEY $YOY_XML
fi

cd /usr/app/boinc

if [[ -z $SKIP_BOINC_MEM_SETTINGS_CHECK ]]; then
  validate_ram_settings
fi

totalmem=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)

if [[ -z $SKIP_BOINC_CPU_SETTINGS_CHECK && "$totalmem" -lt "2500000" ]]; then
  echo "Less than 2.5GB RAM - running single concurrent task"
  update_float_xml_val_with_int max_ncpus_pct 25 "$prefs_file_path"
fi

exec boinc --dir /usr/app/boinc/ --allow_remote_gui_rpc
