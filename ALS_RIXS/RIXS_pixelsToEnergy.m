%Licence: GNU General Public License version 2 (GPLv2)
function energy =  RIXS_pixelsToEnergy(inputWave, angleCounts)
	hc = 1241.5; %in eV*nm
	aberration = 2.93218*10^(-8);
	lambdaOffSet = 6.9145 + 2.0626*10^(-5)*angleCounts + 1.5225*10^(-11)*angleCounts^2;
	lambdaPerPixel = -0.0008469 - 6.426*10^(-10)*angleCounts + 1.3131*10^(-15)*angleCounts^2;
	energy = hc./(lambdaOffSet + lambdaPerPixel.*inputWave + aberration.*inputWave.^2);
end
