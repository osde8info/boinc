#!/bin/bash

mkdir -p /usr/app/boinc/locale
mkdir -p /usr/app/boinc/slots

LHC_XML='account_lhcathome.cern.ch_lhcathome.xml'
ROS_XML='account_boinc.bakerlab.org_rosetta.xml'
UNI_XML='account_universeathome.pl_universe.xml'
YOY_XML='account_www.rechenkraft.net_yoyo.xml'

global_prefs='global_prefs_override.xml'

. start-utils.sh

# remove accounts & projects
rm boinc/account_*

if [[ $LHC_KEY ]]; then
  account_project_enable authenticator $LHC_KEY $LHC_XML
fi

if [[ $ROS_KEY ]]; then
  account_project_enable authenticator $ROS_KEY $ROS_XML
fi

if [[ $UNI_KEY ]]; then
  account_project_enable authenticator $UNI_KEY $UNI_XML
fi

if [[ $YOY_KEY ]]; then
  account_project_enable authenticator $YOY_KEY $YOY_XML
fi

cp configs/* boinc

cd /usr/app/boinc

if [[ -z $SKIP_BOINC_MEM_SETTINGS_CHECK ]]; then
  validate_ram_settings "$global_prefs"
fi

totalmem=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)

if [[ -z $SKIP_BOINC_CPU_SETTINGS_CHECK && "$totalmem" -lt "2500000" ]]; then
  echo "Less than 2.5GB RAM - running single concurrent task"
  # update_float_xml_val_with_int max_ncpus_pct 25 "$global_prefs"
fi

exec boinc --dir /usr/app/boinc/ --allow_remote_gui_rpc
