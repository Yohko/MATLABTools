
**RIXS**:

- load RIXS map with ``RIXSmapdata = RIXS_dloadmap;``
- load XAS scans with ``XASdata = RIXS_dloadSigScan;``

**XPS**:

- load XPS VAMAS file with ``XPSdata = VMS_dload;``
- plot spectra from VAMAS file with ``plotproperties = VMS_plotspectra(data, filenum, spectranum);``
- load CasaXPS report file with ``report = import_VMSreport('report.TXT')``

**Authors**
  - Matthias Richter matthias.h.richter@gmail.com
