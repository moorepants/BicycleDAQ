function err = synchronize_data
format compact; clear all; clf; load HammerTestData
%  nidata = raw pot measurement in volts from the NI board
%  vndata = raw angle data from the VectorNav
%  nisteer = normalized ni data
%  vnsteer = normalized vectornav data

% get the size of each data set
[mvn,nvn]=size(vnsteer)
[mni,nni]=size(nisteer)

n=1:1:mni; dt=0.01; tt=dt*n;

ni=nisteer(241:330); vn=vnsteer(241:330); t=tt(241:330);

 plot(t,ni,'.',t,vn,'.'); legend('ni','vn')
 pause; nivn=[ni vn];
 % since ni data is cleaner use it to shift and interpolate
 tsh=-0.243; tni=t+tsh;% shift time for ni
 tvn=t
 tni
 plot(tni,ni,'.',tvn,vn,'.'); legend('ni','vn')
 % times to interpolate  are those for which vn and ni overlap 
 % and are an unshifted time series part of unchanged tvn
 t_int=tvn(find(tvn<tni(end)))
 ni_int=interp1(tni,ni,t_int)
 %truncate vn before and after times that ni is interpolated to
 tvn_int=tvn(find(tvn<=t_int(end)))
 vn_trunc=vn(find(tvn<=t_int(end)))'
 %vn_trunc=vn_trunc(find(tnv<t_int(end)))
 plot(tni,ni,'.',tvn,vn,'.',t_int,ni_int,'.')%,t_int,vn_trunc,'.')
 legend('ni','vn','ni_int')
 [mvn,nvn]=size(vn_trunc)
 [mni,nni]=size(ni_int)
 
 err=norm(ni_int-vn_trunc)
 
%  plot(nidata)
%  pause
%  plot(vndata)
%  pause
%  plot(nisteer)
%  hold on
%   plot(vnsteer)
 
