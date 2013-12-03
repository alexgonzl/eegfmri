function Sout = eeg_fmri_on_subject_info(subject_num)


Sout = [];
Sout.subject_num = subject_num;
r = [];


% bad channels info for eeg_fmri at cni
% visual inspection of bad channels from continous data set

% visual inspection of bad trials using ft_reject visual
switch subject_num
    case 1
        r(1).badch = [1, 10, 29,35,54, 67,68, 120, 145, 165,174,201,208,234, 208,207,230,55,210,248,257];
        r(1).badtr = [31:36,48,50];
        r(2).badch = [1,10, 32,37,54,67,145,217,223,143,61, 174,156,120,121,219,257, 165];
        r(2).badtr = [24,30,55,61,64,75:80];
        r(3).badch = [238,229,219,217,198,196, 184,185, 174, 166,165, 143,145, 143,120, 92, 61,54, 10, 1,257];
        r(3).badtr = [10,37,39,57,54,60];
        
    case 2
        r(1).badch = [1,10,18,37, 54, 61,67, 68, 73, 81, 82,90:92,101,110,119,187,208,226,240,241,255,257];
        r(1).badtr = [32, 55,64:66];
        r(2).badch = [226, 209, 101,110,90:92,82,73,67,68,61,54,18,10,1,257,37];
        r(2).badtr = [1,30, 64];
        r(3).badch = [1,90, 81, 101, 110, 119,257];
        r(3).badtr = [14:20, 22:28,35,41,44,64:66];
        r(4).badch = [1,10,18,37,54,67,68,73,81,82,90:93,101,110,119,156,257];
        r(4).badtr = [15,17,20,23,42,50,51,52,61:63];
        r(5).badch = [1,54,61,81,90,101,110,119,156,207,257];
        r(5).badtr = [2,5,8,14,17:18,59,61:64];
        
    case 3
        r(1).badch = [1:3,10:12,17:20,25:27,31:33,35,37,38,46,54,234:256];
        r(2).badch = [1:3,10:12,17:20,25:27,31:33,35,37,38,46,54,234:256];%[1:3,10:12,19,20,25,26,31:33,37,38,46,54,241:250,252];
        r(3).badch = [1:3,10:12,17:20,25:27,31:33,35,37,38,46,54,234:256];
        r(1).badtr = 67:142;
        r(2).badtr = [5,14];
        r(3).badtr = 54;
        
    case 6
        r(1).badch = [1,10,25,73,82,67,68,61,54,37,38,31,32,18,19,89,90,91,92,81,55];
        r(2).badch = r(1).badch;
        r(3).badch = r(1).badch;
        r(4).badch = r(1).badch;
        r(5).badch = r(1).badch;
        r(1).badtr = [38,71];
        r(2).badtr = 26;
        r(3).badtr = [44,36,5,35];
        r(4).badtr = [47,65,52,44];
        r(5).badtr = 20;
        
    case 8
        r(1).badch = [1,10,18,31,37,46,54,61,239];
        r(2).badch = r(1).badch;
        r(3).badch = r(1).badch;
        r(4).badch = r(1).badch;
        r(5).badch = r(1).badch;
        r(1).badtr = [3,4,5,8,21,34,52];
        r(2).badtr = [2,14,15,17,56,51];
        r(3).badtr = [19,22,31,33,38,41,44,46,47,49,73];
        r(4).badtr = [9,33,64,76];
        r(5).badtr = [64,68,73,11,39,75];
        
    case 9
        r(1).badch = [1,10,12,18,19,25,37,46,47,54,61,116,233];
        r(2).badch = r(1).badch;
        r(3).badch = r(1).badch;
        r(4).badch = r(1).badch;
        r(5).badch = r(1).badch;
        r(1).badtr = [9,36,52:54,72];
        r(2).badtr = [1,2,4,12,20];
        r(3).badtr = 62;
        r(4).badtr = [1,18,24:26];
        r(5).badtr = [5,11,12,20,37,62:64];
        
    case 10
        r(1).badch = [1,10,18,25,26,31,32,37,54,73,89,129,210,239,241];
        r(2).badch = r(1).badch;
        r(3).badch = r(1).badch;
        r(4).badch = r(1).badch;
        r(5).badch = r(1).badch;
        r(1).badtr = [];
        r(2).badtr = [11,17,59,79];
        r(3).badtr = [75,76];
        r(4).badtr = [1,33,37,38,41];
        r(5).badtr = [11:14,22,25,32,33];
        
    case 11
        r(1).badch = [1,27,37,43,54,68,89,197,225,226];
        r(2).badch = r(1).badch;
        r(3).badch = r(1).badch;
        r(4).badch = r(1).badch;
        r(5).badch = r(1).badch;
        r(1).badtr = [40,42];
        r(2).badtr = [];
        r(3).badtr = [];
        r(4).badtr = 15;
        r(5).badtr = 77;
        
    case 12
        r(1).badch = [1,2,10,18,31,37,38,43,45,46,54,61,67,68,73,82,91,92,93,102,239,251];
        r(2).badch = r(1).badch;
        r(3).badch = r(1).badch;
        r(4).badch = r(1).badch;
        r(5).badch = r(1).badch;
        r(1).badtr = [8,22,44,65,66,68,76,78];
        r(2).badtr = [23, 25, 31, 52];
        r(3).badtr = [1, 2, 3, 25, 48, 64, 70, 73, 75];
        r(4).badtr = [1, 2, 3, 55, 56, 59];
        r(5).badtr = [53, 70, 74];
        
    case 13
        r(1).badch = [1,10,11,18,25,31,37,46,54,61,67,68,73,82,87,89,91,102,231,238,240,244,245];
        r(2).badch = r(1).badch;
        r(3).badch = r(1).badch;
        r(4).badch = r(1).badch;
        r(5).badch = r(1).badch;
        r(1).badtr = [46,48,51:56,63,64];
        r(2).badtr = [34,35,45];
        r(3).badtr = [2, 20, 44, 62];
        r(4).badtr = [2, 3, 4, 6, 14, 29, 65, 77];
        r(5).badtr = [19, 26, 41, 43, 71];
        
    otherwise
        r(1).badch = [];
        r(2).badch = r(1).badch;
        r(3).badch = r(1).badch;
        r(4).badch = r(1).badch;
        r(5).badch = r(1).badch;
        r(1).badtr = [];
        r(2).badtr = [];
        r(3).badtr = [];
        r(4).badtr = [];
        r(5).badtr = [];
end
Sout.r = r;
%%

switch subject_num
    case 1
        %run breakthrough
        % runs 1,2 are empty
        % run 5 is a repeat of run 4
        % runs 3,4 and 6 are valid
        run_nums = [3,4,6];
        
        % files
        filename(1) = {'Acc1_retrieve_1_14Jul11out(3).mat'};
        filename(2) = {'Acc1_retrieve_1_14Jul11out(4).mat'};
        filename(3) = {'Acc1_retrieve_1_14Jul11out(6).mat'};
        
        % mapping of button box responses
        R = 4;
        HCO = 9;
        LCO = 8;
        LCN = 7;
        HCN = 6;
        
    case 2
        %run breakthrough
        % run 3 is a repeat of 1
        % run 6 not ran
        run_nums = [1,2];%,3,4,5];
        
        % files
        filename(1) = {'Acc1_retrieve_sub1_date_21Jul11out.mat'};
        filename(2) = {'Acc1_retrieve_1_21Jul11out(2).mat'};
        filename(3) = {'Acc1_retrieve_1_21Jul11out(3)_repeatof1.mat'};
        filename(4) = {'Acc1_retrieve_1_21Jul11out(4).mat'};
        filename(5) = {'Acc1_retrieve_1_21Jul11out(5).mat'};
        
        R = 9;
        HCO = 1;
        LCO = 2;
        LCN = 3;
        HCN = 4;
        
    case 3
        run_nums =1:3;
        
        filename(1) = {'Acc1_retrieve_sub1_date_31Aug11out_respsRecovered.mat'};
        filename(2) = {'Acc1_retrieve_1_31Aug11out(6)_respsRecovered.mat'};
        filename(3) = {'Acc1_retrieve_1_31Aug11out(7)_respsRecovered.mat'};
        
        R = 7;
        HCO = 1;
        LCO = 2;
        LCN = 3;
        HCN = 4;
        
    case 4
        run_nums =1:5;
        filename(1)= {'Acc1_retrieve_1_12Sep11out(2).mat'}';
        filename(2)= {'Acc1_retrieve_1_12Sep11out(3).mat'}';
        filename(3)= {'Acc1_retrieve_1_12Sep11out(4).mat'}';
        filename(4)= {'Acc1_retrieve_1_12Sep11out(5).mat'}';
        filename(5)= {'Acc1_retrieve_1_12Sep11out(6).mat'}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 5
        run_nums =1:5;
        filename(1)= {'Acc1_retrieve_2_13Sep11out(1).mat'}';
        filename(2)= {'Acc1_retrieve_2_13Sep11out(2).mat'}';
        filename(3)= {'Acc1_retrieve_2_13Sep11out(3).mat'}';
        filename(4)= {'Acc1_retrieve_2_13Sep11out(4).mat'}';
        filename(5)= {'Acc1_retrieve_2_13Sep11out(5).mat'}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 6
        run_nums =1:5;
        filename(1)= {'Acc1_retrieve_3_15Sep11out(1).mat'}';
        filename(2)= {'Acc1_retrieve_3_15Sep11out(2).mat'}';
        filename(3)= {'Acc1_retrieve_3_15Sep11out(3).mat'}';
        filename(4)= {'Acc1_retrieve_3_15Sep11out(4).mat'}';
        filename(5)= {'Acc1_retrieve_3_15Sep11out(5).mat'}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 7
        run_nums =[1,2,4,5];
        filename(1)= {'Acc1_retrieve_4_19Sep11out(2).mat'}';
        filename(2)= {'Acc1_retrieve_4_19Sep11out(3).mat'}';
        filename(3)= {'Acc1_retrieve_4_19Sep11out(6).mat'}';
        filename(4)= {'Acc1_retrieve_4_19Sep11out(7).mat'}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 8
        run_nums =1:5;
        filename(1)= {'Acc1_retrieve_5_21Sep11out(1).mat'}';
        filename(2)= {'Acc1_retrieve_5_21Sep11out(2).mat'}';
        filename(3)= {'Acc1_retrieve_5_21Sep11out(4).mat'}';
        filename(4)= {'Acc1_retrieve_5_21Sep11out(5).mat'}';
        filename(5)= {'Acc1_retrieve_5_21Sep11out(6).mat'}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 9
        run_nums =1:5;
        filename(1)= {'Acc1_retrieve_6_22Sep11out(1).mat'}';
        filename(2)= {'Acc1_retrieve_6_22Sep11out(2).mat'}';
        filename(3)= {'Acc1_retrieve_6_22Sep11out(3).mat'}';
        filename(4)= {'Acc1_retrieve_6_22Sep11out(4).mat'}';
        filename(5)= {'Acc1_retrieve_6_22Sep11out(5).mat'}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 10
        run_nums =1:5;
        filename(1)= {'Acc1_retrieve_7_27Sep11out(2).mat'}';
        filename(2)= {'Acc1_retrieve_7_27Sep11out(3).mat'}';
        filename(3)= {'Acc1_retrieve_7_27Sep11out(4).mat'}';
        filename(4)= {'Acc1_retrieve_7_27Sep11out(5).mat'}';
        filename(5)= {'Acc1_retrieve_7_27Sep11out(6).mat'}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 11
        run_nums =1:5;
        filename(1)= {'Acc1_retrieve_8_29Sep11out(1).mat'}';
        filename(2)= {'Acc1_retrieve_8_29Sep11out(2).mat'}';
        filename(3)= {'Acc1_retrieve_8_29Sep11out(3).mat'}';
        filename(4)= {'Acc1_retrieve_8_29Sep11out(4).mat'}';
        filename(5)= {'Acc1_retrieve_8_29Sep11out(5).mat'}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 12
        run_nums =1:5;
        filename(1)= {'Acc1_retrieve_9_05Oct11out(1).mat'}';
        filename(2)= {'Acc1_retrieve_9_05Oct11out(2).mat'}';
        filename(3)= {'Acc1_retrieve_9_05Oct11out(3).mat'}';
        filename(4)= {'Acc1_retrieve_9_05Oct11out(4).mat'}';
        filename(5)= {'Acc1_retrieve_9_05Oct11out(5).mat'}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 13
        run_nums =1:5;
        filename(1)= {'Acc1_retrieve_10_14Oct11out(1).mat'}';
        filename(2)= {'Acc1_retrieve_10_14Oct11out(2).mat'}';
        filename(3)= {'Acc1_retrieve_10_14Oct11out(3).mat'}';
        filename(4)= {'Acc1_retrieve_10_14Oct11out(4).mat'}';
        filename(5)= {'Acc1_retrieve_10_14Oct11out(5).mat'}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 14
        run_nums =1:5;
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 15
        run_nums =1:5;
        bs = '17';
        date = '04april12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 16
        run_nums =1:5;
        bs = '18';
        date = '05Apr12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 17
        run_nums =1:5;
        bs = '19';
        date = '07Apr12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(6).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(7).mat']}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 18
        run_nums =1:5;
        
        bs = '20';
        date = '07April12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
        
    case 19
        run_nums =1:5;
        bs = '20';
        date = '11Apr12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
    case 20
        run_nums =1:5;
        bs = '21';
        date = '29Apr12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
    case 21
        run_nums =1:4;
        bs = '22';
        date = '01May12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
        R = 1;
        HCO = 2;
        LCO = 3;
        LCN = 4;
        HCN = 5;
    case 22
        run_nums =1:5;
        bs = '21';
        date = '11Nov12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
        R = 6;
        HCO = 7;
        LCO = 8;
        LCN = 9;
        HCN = 'a';
        
    case 23
        run_nums =1:5;
        bs = '22';
        date = '11Nov12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
         R = 6;
        HCO = 7;
        LCO = 8;
        LCN = 9;
        HCN = 'a';
        
    case 24
        run_nums =1:5;
        bs = '23';
        date = '11Nov12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
     R = 6;
        HCO = 7;
        LCO = 8;
        LCN = 9;
        HCN = 'a';
        
    case 25
        run_nums =1:5;
        bs = '24';
        date = '14Nov12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
         R = 6;
        HCO = 7;
        LCO = 8;
        LCN = 9;
        HCN = 'a';
        
    case 26
        run_nums =1:5;
        bs = '25';
        date = '14Nov12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(3).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        
        R = 6;
        HCO = 7;
        LCO = 8;
        LCN = 9;
        HCN = 'a';
                
    case 27
        run_nums =1:5;
        bs = '26';
        date = '15Nov12';
        filename(1)= {['Acc1_retrieve_' bs '_' date 'out(1).mat']}';
        filename(2)= {['Acc1_retrieve_' bs '_' date 'out(2).mat']}';
        filename(3)= {['Acc1_retrieve_' bs '_' date 'out(4).mat']}';
        filename(4)= {['Acc1_retrieve_' bs '_' date 'out(5).mat']}';
        filename(5)= {['Acc1_retrieve_' bs '_' date 'out(6).mat']}';
        
         R = 6;
        HCO = 7;
        LCO = 8;
        LCN = 9;
        HCN = 'a';
end

Sout.run_nums = run_nums;
Sout.filename = filename;
Sout.R = R; Sout.HCO = HCO; Sout.LCO = LCO; Sout.HCN = HCN; Sout.LCN = LCN;
end