# Trace Driven Emulation of Rate Adaptation (TDE-RA) Project

This is a simulation platform for the rate adaptation algorithm.
The platform is based on MATLAB for off-line process because MATLAB has lots of useful toolbox to simplify the design.
The platform includes basic signal process blocks in PHY layer, including channel coding, modulation, synchronization, channel estimation.
You can design your own rate adaptation algorithm by deploying the trace-driven evaluation.
The traces can be collected from commercial wireless devices or USRP.

## Supported Standard

1. IEEE 802.11a standard (Legacy mode)

The trace-driven emulation platform for IEEE 802.11a standard is based on the [*comm toolbox*](https://www.mathworks.com/help/comm/).

You can run 

    IEEE80211a_BERvsSNR_threshold.m

to get the BER vs SNR curve and determine the SNR threshold for each modulation and code scheme (MCS).

 
>    Note: The rate adaptation code for IEEE 802.11a standard is not maintained.
 

2. IEEE 802.11ac standard (Very High Throughput mode, VHT)

The trace-driven emulation platform for IEEE 802.11ac standard is based on the [*WLAN toolbox*](https://www.mathworks.com/help/wlan/).

You can run
    
    IEEE80211ac_RA_TDE.m

to display the emulation results of the rate adaptation. 

# Rate adaptation for IEEE 802.11ac standard

The main function of the trace-driven emulation is *IEEE80211ac_RA_TDE*.
It is implemented a SNR-based rate adaptation algorithm and a fixed rate algorithm.

## Options

Some options in *IEEE80211ac_RA_TDE* can be used to display different results.

* __traceFile__ is the file of the collected trace. The format of this file is *.mat* (i.e., the data file of MATLAB). For now, the collect trace is based on the [Atheros CSI tool](https://wands.sg/research/wifi/AtherosCSI/).
* __traceDur__ is the time duration of the collected trace. The unit is S. For example, *traceDur = [20, 90]* indicates the channel model is built based on the collected trace from 20s to 90s.
* __THE__ is the SNR threshold of each MCS. This parameter is used to determine the MCS in the rate adaptation algorithm.
* __BITRATE__ is the bit rate in Mbps of each MCS. This is determined from the [Wikipedia of IEEE 802.11ac standard](https://en.wikipedia.org/wiki/IEEE_802.11ac-2013).


## Collect traces form Atheros CSI tool.

For now, we only implement an interface to read the traces from the [Atheros CSI tool](https://wands.sg/research/wifi/AtherosCSI/).
You need to install Atheros CSI tool and collects traces from the tool.
In the CSI tool, it provides a MATLAB interface to display the csi traces by using *read_log_file*.
After running it, you can use 

    save csi
in MATLAB to save the traces into a *csi.mat* file.
Finally, you can input the filename into __traceFile__, and we have implemented a interface named *chModelfromTraces* to model the channel from the collected trace.

