function convert_txt_jpg(filename)
        fid = fopen(filename);
        tline = fgets(fid);
        %disp(tline);
        
      %%
        %optain the size and load the data in a flow matrix
        s =str2num(tline);
        flow = zeros(s(2),s(1),2);

        j = 1; %horizontal and vertical indices
        i = 1;
        tline = fgets(fid);
        while ischar(tline)
            v =str2num(tline);
            flow(j,i,:) = v;
            if i == s(1) 
                i=1;
                j = j+1;
            else
                i = i+1;
            end
            tline = fgets(fid);
        end
        fclose(fid);
        %disp('Data read.');
       %%
        max_flow = 60;%abs(max(flow(:)));%8; % maximum absolute value of flow (!need to be calculated and set!)
        scalef = 128/max_flow;
        
        x = flow(:,:,1); y = flow(:,:,2);
        %if range(x(:))<0.5 && range(y(:))<0.5 % some frames are duplicate; ignore flow for those as it will be confusing for the CNN
          %  exit();
        %end

        mag_flow = sqrt(sum(flow.^2,3));

        flow = flow*scalef;  % scale flow
        flow = flow+128;    % center it around 128
        flow(flow<0) = 0;
        flow(flow>255) = 255; % crop the values below 0 and above 255

        mag_flow = mag_flow*scalef; % same for magnitude
        mag_flow = mag_flow+128;
        mag_flow(mag_flow<0) = 0;
        mag_flow(mag_flow>255) = 255;

        im = uint8(cat(3,flow,mag_flow)); % concatenate flow_x, flow_y and magnitude
        name = strsplit(filename,'.');
        imwrite(im,strjoin([name(1) '.jpg'],''));
        disp('finished: ');
	disp(name(1));
        exit();
       
        

        
