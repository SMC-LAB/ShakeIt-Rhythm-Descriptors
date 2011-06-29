function outBeats = eventPeakAlign(inBeats,feature,featureFs,tolerance);
%
% function outBeats = eventPeakAlign(inBeats,feature,featureFs);
%
% lock beats to peaks of a feature. 
% here we imagine that it could be for beats and an onset detection function
% but it could equally work for tempo candidates and an autocorrelation function

%    Shake-It Rhythm Descriptors - low level features related to rhythmic structure of musical audio
%    Copyright (C) 2011  Matthew Davies and INESC Porto
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.


% if tolerance is unspecified set it at +/- 50ms
if nargin<4
	tolerance = 0.05;
end
% want to put tolerance into the range of the feature
tolerance = ceil(tolerance*featureFs);

% first put inBeats into feature sampling domain
% assume that beat times are in seconds.
inBeats = round(inBeats * featureFs); 

% now check if beats are within range ... can also catch rounding out of range errors
inBeats(inBeats < 1) = []; % can't have a beat at time 0;
inBeats(inBeats > length(feature)) = []; % remove any off the end too

nBeats = length(inBeats);

% want to adjust the beats to they match the peaks of the feature
for i=1:nBeats,
	% look at the feature around the beats.. and re-align beats to max of feature within tolerance range
	featureSeg = feature(max(1,inBeats(i)-tolerance) : min(inBeats(i)+tolerance,length(feature)));
	[tmpval4,tmpindex4] = max(featureSeg);
	outBeats(i) = max(1, ( inBeats(i) + tmpindex4 - tolerance -1 ));  % need the max statement in case this goes negative
end
% i'm assuming that can only happen for one beat... might need a better fix than the one i put in.

