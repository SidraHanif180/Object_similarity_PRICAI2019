function net = fast_rcnn_init_siamese (opts)
addpath('G:\Sidra\retreival_pascal\cnngeometric_matconvnet-master\matlab\auxiliary_functions');
opts.featExtLastLayer ='relu5_3';
opts.featExtLastLayer2 ='relu5_3';
net = fast_rcnn_init(...
    'piecewise',opts.piecewise,...
    'modelPath',opts.modelPath);
 net.removeLayer(net.layers(37).name); %37 39
 net.removeLayer(net.layers(38).name); %38 40
%%
netStruct = net.saveobj;
netStruct1 = netStruct;
netStruct2 = netStruct;
net1=dagnn.DagNN.loadobj(netStruct1);
net2=dagnn.DagNN.loadobj(netStruct2);
Nlayers = net1.getLayerIndex(opts.featExtLastLayer);

while length(net1.layers)>Nlayers
    net1.removeLayer(net1.layers(end).name);
end
Nlayers2 = net2.getLayerIndex(opts.featExtLastLayer2);

for i= Nlayers2:-1:1
    net2.removeLayer(net2.layers(1).name);
end

    net1.addLayer('roipool', dagnn.ROIPooling('method','max','transform',1/16,...
    'subdivisions',[7,7],'flatten',0), ...
    {net1.layers(end).outputs{1},'rois'}, 'xRP');

    
    netStruct11 = net1.saveobj;
    netStruct11.vars(1).name='input';
    netStruct11.layers(1).inputs{1}='input';
    netStruct21 = netStruct11;
%     netStruct31 = netStruct11;
    % rename layers on each branch    
    netStruct11 = netNamePrefix(netStruct11,'AN1','AN1','AN');
    netStruct21 = netNamePrefix(netStruct21,'AN2','AN2','AN');
    %netStruct31 = netNamePrefix(netStruct31,'AN3','AN3','AN');
    netStructFused = fuseNetStruct(netStruct11, netStruct21);
   % netStructFused = fuseNetStruct(netStructFused, netStruct31);
    %% concatenataion layer
    
    %%% Convert back to dagNN
     net1 = dagnn.DagNN.loadobj(netStructFused);
    net1.addLayer('roi_concat',dagnn.Concat('dim',3),...
        {'AN1xRP', 'AN2xRP'},{'AN4xRP'}, {}) ;
    %%
%     net1.addLayer('roisim2', dagnn.ROIPooling('method','max','transform',1/16,...
%     'subdivisions',[7,7],'flatten',0), ...
%         {'AN2xRP','rois2'}, 'A2xsim');
%     net1_siamese.addLayer('roi_concat_sim',dagnnExtra.Concat('dim',3),...
%         {'AN1xRP', 'AN2xsim'},{'xRPsim'}, {}) ;
    net2.removeLayer(net2.layers(7).name); %7 9
    net2.removeLayer(net2.layers(8).name);
%%
 netStruct_siamese = net1.saveobj; 
 netStruct_regress = net2.saveobj;  
 netStruct_regress = netNamePrefix(netStruct_regress,'AN4','AN4','AN4'); 
 netStruct_regress.layers(1).block.size = [7,7,1024,4096];
 netStruct_regress.params(1).value = 0.001 * randn(7,7,1024,4096,'single');
 netStruct_regress.params(2).value = zeros(4096,1,'single');
 netStruct_regress_BB = netStruct_regress;
 netStructCombine =  fuseNetStruct(netStruct_siamese, netStruct_regress_BB);
 
 netStruct_sim11 = net2.saveobj; %net2.layers(7).block.size  
 netStruct_sim11.layers(7).block.size = [1,1,4096,1000];
 netStruct_sim11.params(5).value = 0.001 * randn(1,1,4096,1000,'single');
 netStruct_sim11.params(6).value = zeros(1,1000,'single');
 netStruct_sim12 = netStruct_sim11;
 netStruct_sim11 = netNamePrefix(netStruct_sim11,'AN5','AN5','AN5');
 netStruct_sim12 = netNamePrefix(netStruct_sim12,'AN6','AN6','AN5');
 
%  netStruct_sim12 = netStruct_sim11;
%  netStruct_sim11 = netNamePrefix(netStruct_sim11,'AN4','AN4','AN4');
%  netStruct_sim12 = netNamePrefix(netStruct_sim12,'AN5','AN5','AN4');
  netStructCombine = fuseNetStruct(netStructCombine, netStruct_sim11);
  netStructCombine = fuseNetStruct(netStructCombine, netStruct_sim12);
 clear net
 net = dagnn.DagNN.loadobj(netStructCombine);
 net.addLayer('softmaxref', dagnnLoss.SoftMaxCustom(), ...
    {'AN5predbbox'}, 'AN5predbbox1');
 net.addLayer('softmaxpos', dagnnLoss.SoftMaxCustom(), ...
    {'AN6predbbox'}, 'AN6predbbox1');
 %% similarity layer
%     net.addLayer('roipool2AN1', dagnn.ROIPooling('method','max','transform',1/16,...
%     'subdivisions',[1,1],'flatten',0), ...
%     {'AN1x30','AN1rois'}, 'xRP12');
    net.addLayer('roipoolB',dagnnLoss.ROIProposal(), ...
    {'AN4predbbox','AN2rois'}, ...
    'roisestimate',{});  
    net.addLayer('roipoolpos', dagnn.ROIPooling('method','max','transform',1/16,...
    'subdivisions',[7,7],'flatten',0), ...
    {'AN2x30','roisestimate'}, 'xRPpositive');
%     net.addLayer('roi_concatsim',dagnn.Concat('dim',3),...
%         {'AN1xRP', 'xRPpositive'},{'xRP'}, {}) ;
%     net.addLayer('roipoolneg', dagnnLoss.ROIPooling_custom_5proposals(), ...
%     {'AN3x30','rois_negative'}, 'xRPnegative');

%     net.addLayer('combineROI', dagnnLoss.combineROI(), ...
%     {'xRPpositive','xRPnegative', 'roisestimate','rois_negative'}, 'simxRP');

%     net.addLayer('cosineSim', dagnnLoss.CosSimLoss(), ...
%     {'xRP12','xRPpositive','xRPnegative', 'roisestimate',...
%     'rois_negative'}, 'final_sim');
%     net.addLayer('cosineSim', dagnnLoss.CosSimLoss(), ...
%     {'xRP12','xRPpositive'}, 'final_sim');
% net.addLayer('InputConcat',dagnnLoss.InputConcat(),...
%     {'xRPnegative','rois_negative' }, ...
%     'xRPnegative_new',{});

%     net.addLayer('sim_concat',dagnn.Concat('dim',3),...
%         {'AN1xRP', 'xRPpositive'},{'AN5xRP'}, {}) ;
        net.addLayer('label_gen',dagnnLoss.labelGen(), ...
    {'AN4predbbox','proposal','gtAll'}, ...
    'label',{});
%     net.addLayer('sigmoid',dagnn.ReLU(),...
%     {'AN5predbbox'}, ...
%     'predbbox1',{});
    net.addLayer('contloss',dagnnLoss.ContrastiveLoss(), ...
    {'AN5predbbox1','AN6predbbox1', 'label','label_class'}, ...
    'losssim',{}); 
     
     net.addLayer('lossbbox',dagnnLoss.LossSmoothL1(), ...
    {'AN4predbbox','targets','label_class'}, ...
    'lossbbox',{});
net.layers(71).inputs = 'AN1xRP';
net.layers(78).inputs = 'xRPpositive';
 %%
 net.rebuild();
 