# Trace Driven Simulation
This is a trace driven simulation code for 802.11a protocol. 
The transmission pipeline include rate adaptation, channel coding, modulation, sync, chanel estimation, demodulation.

    Note: Some block such as MAC header, frame detection, synchronization with pilot need to be added.

The function tree is

```
TDS_OFDM_SISO.m
|-- GlobalVariables.m
|-- OFDM_TX_Pipeline.m
        |
        |
|-- OFDM_RX_Pipeline.m
        |
        |
```
