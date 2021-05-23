function [] = phil_plot_pinned_actuators(dm,title_str)



pinned = dm.pinned
Vpinned = dm.Vpinned


color_normal_act = 0.0
color_pinned_act = 0.2
color_railed_act = 0.9
color_stuck_act = 0.6


V = color_normal_act*ones(64,64)



%User inputs:

% The voltage in which the actuator is considered railed
railedV = 200;

% The voltage in which the actuator is considered pinned
pinnedV = 0


% Indices of stuck actuators that are not pinned or railed in Vpinned
Vpinned_stuck_ind = find( (Vpinned < railedV) .* (Vpinned > 0) )

% Indices of railed actuators in Vpinned
Vpinned_railed_ind = find( (Vpinned >= railedV) )

% Indices of pinned actuators in Vpinned
Vpinned_pinned_ind = find( (Vpinned <= pinnedV) )




stuck_act_ind = pinned(Vpinned_stuck_ind)
V(stuck_act_ind) = color_stuck_act

pinned_act_ind = pinned(Vpinned_pinned_ind)
V(pinned_act_ind) = color_pinned_act;

railed_act_ind = pinned(Vpinned_railed_ind)
V(railed_act_ind) = color_railed_act;


%V(pinned) = Vpinned_norm;

%pinned(1) = find(Vpinned == 0)

% Number of unique values in V
nu = length(unique(V))

cmap = parula(nu)


figure;
imagesc(V, [0.0 1.0]);
colorbar
caxis([0.0 1.0])
numCoins = length(unique(V))
title(title_str)

%Get a different color for each coin. Add one for background and skip it
allColors = parula(numCoins + 1);

allColors = allColors(2:end,:);


allColors = [0.2392  0.149  0.6588; ...
    0.26 0.40 0.99; ...
    0.0704    0.7457    0.725; ...
    0.98 0.83 0.18...
    ]



labels_arr = {'Normal','Pinned','Stuck','Railed'}



imlegend(allColors, labels_arr);



    function imlegend(colorArr, labelsArr)
        % For instance if two legend entries are needed:
        % colorArr =
        %   Nx3 array of doubles. Each entry should be an RGB percentage value between 0 and 1
        %
        % labelsArr =
        %   1�N cell array
        %     {'First name here'}    {'Second name here'}    {'etc'}
        hold on;
        for ii = 1:length(labelsArr)
            % Make a new legend entry for each label. 'color' contains a 0->255 RGB triplet
            scatter([],[],1, colorArr(ii,:), 'filled', 'DisplayName', labelsArr{ii});
        end
        hold off;
        legend();
    end

end