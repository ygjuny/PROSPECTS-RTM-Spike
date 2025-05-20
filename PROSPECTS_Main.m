% _______________________________________________________________________
% Main function for PROSPECTS model
% Version 1.0 (May, 20th 20205)
% _______________________________________________________________________
% for any question or request, please contact:
%
% Dr. Guijun Yang & Mr. Hongrui Wen
% State Key Laboratory of Loess Science, College of Geological Engineering and Geomatics, Chang’an University, Xi’an, 710064, China
% Key Laboratory of Quantitative Remote Sensing in Agriculture of Ministry of Agriculture and Rural Affairs, Information Technology Research Center, Beijing Academy of Agriculture and Forestry Sciences, Beijing 100097, China
% E-mail: guijun.yang@163.com & hhwenhongrui@126.com
%
% https://github.com/ygjuny/PROSPECTS-RTM-Spike
% _______________________________________________________________________
% Function: Simulate spike spectra properties from 400 nm to 2500 nm with 1 nm interval
%    Input:
%           - AGDD = accumulated growing degree days in °C
%           - Cab = chlorophyll a+b content in ug/cm?
%           - Car = carotenoids content in ug/cm?
%           - Cw  = equivalent water thickness in g/cm? or cm
%           - Cm  = dry matter content in g/cm?
%   Output:spike reflectance
%
% Acknowledgement: The authors thank the PROPSECT team for providing the
%                  calctav.m.

% AGDD来驱动PROSPECTS
parameters = readmatrix('Metadata.xlsx', 'Sheet', 'Spike_Database', 'Range', 'A2');
Cab_total = parameters(:,7);
Car_total = parameters(:,8);
Cw_total = parameters(:,9);
Cm_total = parameters(:,10);
AGDD_total = parameters(:,3);
results = cell(2101, 64);  % 创建一个 cell 数组存储结果
W_all = cell(2101, 64);  % 创建一个 cell 数组存储结果
LRT_all = cell(2101, 64);  % 创建一个 cell 数组存储结果
for i = 1:length(Cm_total)
    Cab = Cab_total(i);
    Car = Car_total(i);
    Cw = Cw_total(i);
    Cm = Cm_total(i);
    AGDD = AGDD_total(i);
    disp(i);
    LRT = PROSPECTS_Model(AGDD,Cab,Car,Cw,Cm);
    Wavelength = LRT(:, 1);
    R = LRT(:, 2);

   % 将结果逐行存储到 cell 数组中
    for j = 1:2101
        results{j, i} = [Wavelength(j), R(j)];       
    end
    
end


writecell([results], 'test.xlsx', 'sheet', 'dnr');  % 写入表头和数据

