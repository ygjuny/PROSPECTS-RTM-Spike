# PROSPECTS-RTM-Spike
# Model Description
A spike spectrum model that simulates winter wheat spike reflectance across the 400–2500 nm spectral range, with input of accumulated growing degree days, chlorophyll content, equivalent water thickness, and dry matter content etc. The model is built following the Multi-layer flat plate to describe the spike radiatve transferring process, which could account for the effects of the dynamic growth of spikes on the structural characteristics. The model provides an efficient and physically approach to accurately simulate spike spectra and retrieve key spike functional traits from hyperspectral remote sensing measurements.
# File Description
1. Please start with the PROSPECTS_Main.m, which is the main function and can display the output figures.  
2. Metadata.xlsx is the input parameters, and the description of the order of input is in PROSPECTS_Main.m. You can also provide the input in PROSPECTS_Main.m after slightly changing the code.  
3. spike_spectrum_simulation.xlsx is the output, and the order is [wavelength, spike reflectance].  
4. The key code of the PROSPECTS model is in PROSPECTS_Model.m.   
5. dataSpec_PROSPECTSB.m and calctav.m are about the specific absorption coefficient of spike biochemical constituents and refractive index parameter, which do not need the users to be quite familiar with. 
