#!/bin/bash

# Data taken in the style of
# https://worldview.earthdata.nasa.gov/?p=geographic&l=SMAP_L4_Emult_Average&t=2018-08-01-T00%3A00%3A00Z&z=3&v=-180,-90,180,90


# Go into folder where the script should be executed
FPATH=/home/${USER}/Desktop/nasa

# Important image parameters
AREA=-60.0,-170.0,80.0,180.0
WIDTH=1000
HEIGHT=400

# Loop through time
TIMESTAMP=2019-05-01
ENDDATE=2012-01-01
OFFSET="- 1 day"

# Layers to pull
LAYER_LIST=(
    SMAP_L4_Emult_Average
    MODIS_Terra_EVI_8Day
    SMAP_L4_Soil_Temperature_Layer_1
    SMAP_L2_Passive_Enhanced_Day_Soil_Moisture_Option1
    SMAP_L4_Uncertainty_Mean_Net_Ecosystem_Exchange
    SMAP_L4_Mean_Net_Ecosystem_Exchange
    SMAP_L4_Mean_Heterotrophic_Respiration
    MODIS_Combined_Thermal_Anomalies_All
    MODIS_Terra_Chlorophyll_A
    MODIS_Aqua_Chlorophyll_A
    SMAP_L1_Passive_Enhanced_Brightness_Temp_Fore_H
    AMSUA_NOAA15_Brightness_Temp_Channel_1
    VIIRS_SNPP_CorrectedReflectance_TrueColor
    AIRS_Surface_Air_Temperature_Monthly_Day
    MERRA2_Surface_Skin_Temperature_Monthly
    MODIS_Terra_L3_SST_Thermal_9km_Day_Monthly
    MODIS_Aqua_L3_SST_Thermal_9km_Day_Monthly
    SMAP_L3_Sea_Surface_Salinity_CAP_Monthly
    AIRS_Surface_Relative_Humidity_Monthly_Day
    MERRA2_Incident_Shortwave_Over_Land_Monthly
    MERRA2_Evaporation_from_Turbulence_Monthly
    MISR_Directional_Hemispherical_Reflectance_Average_Natural_Color_Monthly
    MERRA2_Carbon_Monoxide_Emission_Monthly
)

while [ "${TIMESTAMP}" != ${ENDDATE} ]
do

    # Layer to look into
    for layer in ${LAYER_LIST[@]}
    do

        wget "https://wvs.earthdata.nasa.gov/api/v1/snapshot?REQUEST=GetSnapshot&TIME=${TIMESTAMP}&BBOX=${AREA}&CRS=EPSG:4326&LAYERS=${layer}&FORMAT=image/png&WIDTH=${WIDTH}&HEIGHT=${HEIGHT}" \
            -O ${FPATH}/nasa_${layer}_${TIMESTAMP}.png \
            --connect-timeout=60 \
            --read-timeout=300 \
            --tries 5
        # This wget command will try to connect to the server for 60s or try to
        # download the file for a total of 5min. If this didn't work, it will
        # try again anew. This step is repeated for a total of 5 tries
    done
    TIMESTAMP=$(date -I -d "${TIMESTAMP} ${OFFSET}")
done
