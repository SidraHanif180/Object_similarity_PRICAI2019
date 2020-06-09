classdef CosSimLoss < dagnn.Layer
    properties
        margin = 1;
    end
    
    methods
        function outputs = forward(obj, inputs, params)
            AN1 = inputs{1,1}; pos = inputs{1,2}; %neg = inputs{1,3};
            %roi_est = squeeze(inputs{1,3}); %roi_neg = squeeze(inputs{1,5});
            %ind_pos = roi_est(1,:); %ind_neg = roi_neg(1,:);
            %AN1_pos = AN1(:,:,:,ind_pos); AN1_neg = AN1(:,:,:,ind_neg);
            cosim =[];
            for k=1: size(AN1,4)
                AN1_batch = AN1(:,:,:,k);
                %curr_indp = find (ind_pos ==k)  ;
                %for k1 = 1: size(curr_indp,2)
                    coSim_pos = pdist2(gather(AN1_batch(:))',...
                        gather(squeeze(pos(:,:,:,k)))',...
                        'cosine');
                %end
%                 curr_indn = find (ind_neg ==k)  ;
%                 if ~isempty(curr_indn)
%                     for k1 = 1: size(curr_indn,2)
%                         coSim_neg(k1) = pdist2(gather(AN1_batch(:))',...
%                             gather(squeeze(neg(:,:,:,curr_indn(k1))))',...
%                             'cosine');
%                     end
%                 end
%                 if ~isempty(curr_indn)
%                     cosim{k} =[coSim_pos;coSim_neg']; clear coSim_neg;
%                 else  
            cosim{k} = [coSim_pos];
%                 end
            end
            outputs{1} = cosim;
            
            %obj.accumulateAverage(inputs, outputs);
        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
           
           AN1 = inputs{1,1}; pos = inputs{1,2}; %neg = inputs{1,3};
%              roi_est = squeeze(inputs{1,3}); %roi_neg = squeeze(inputs{1,5});
%             ind_pos = roi_est(1,:); %ind_neg = roi_neg(1,:);
%             dydx = v ./ (xn*vn) - x'*v*x ./ (xn^3*vn);
%             dydv = x ./ (xn*vn) - v'*x*v ./ (vn^3*xn);
            dpos =[]; dneg =[];
            for k=1: size(AN1,4)
                AN1_batch = gather(squeeze(AN1(:,:,:,k))); pos_k = gather(squeeze(pos(:,:,:,k)));
                AN1_norm = norm (AN1_batch); pos_k_norm = norm(pos_k);
                
                dAN1_pos =  pos_k./(AN1_norm * pos_k_norm) - ...
                    (AN1_batch'*pos_k*AN1_batch)./ (AN1_norm^3*pos_k_norm) ;
                dposk =  AN1_batch./(AN1_norm * pos_k_norm) - ...
                    (pos_k'*AN1_batch*pos_k)./ (AN1_norm*pos_k_norm^3) ;
                %end
%                 curr_indn = find (ind_neg ==k)  ;
%                 if ~isempty(curr_indn)
%                     for k1 = 1: size(curr_indn,2)
%                         neg_k = gather(squeeze(neg(:,:,:,curr_indn(k1)))); 
%                         neg_k_norm = norm(neg_k);
%                         dAN1_neg(:,k1) = neg_k./(AN1_norm * neg_k_norm) - ...
%                     (AN1_batch'*neg_k*AN1_batch)./ (AN1_norm^3*neg_k_norm) ;
%                      dnegk(:,k1) =  AN1_batch./(AN1_norm * pos_k_norm) - ...
%                     (neg_k'*AN1_batch*neg_k)./ (AN1_norm*neg_k_norm^3) ;
%                 
%                     end
%                 end
%                 if ~isempty(curr_indn)
%                 dAN1{k} = [dAN1_pos , dAN1_neg];                
%                 else  
            dAN1{k} =[dAN1_pos];
%                 end
%                 if ~isempty(curr_indn)
%                     dcosim{k} =[dcoSim_pos;dcoSim_neg'];
%                 else  dcosim{k} =[dcoSim_pos];
%                 end
            %dAN1_mean(:,k) = mean(dAN1{k},2);
            dAN1_mean(:,k) = dAN1{k};
            dpos = [dpos,dposk];
%             if ~isempty(curr_indn), dneg = [dneg,dnegk]; clear dnegk,  end            
             end
            
            derInputs = {gpuArray(reshape(dAN1_mean, size(inputs{1,1}))),...
                gpuArray(reshape(dpos, size(inputs{1,2}))), ...
                };
            derParams = {} ;
            %gpuArray(reshape(dneg, size(inputs{1,3})))
     
        end
        
        function obj = CosSimLoss(varargin)
            obj.load(varargin{:}) ;
        end
    end
    end


