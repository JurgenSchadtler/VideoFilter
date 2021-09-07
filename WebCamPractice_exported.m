classdef WebCamPractice_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        TurnOnButton                   matlab.ui.control.Button
        LinealFilterButton             matlab.ui.control.Button
        LaplaceFilterButton            matlab.ui.control.Button
        LowPassButton                  matlab.ui.control.Button
        HighPassButton                 matlab.ui.control.Button
        AGENTESINTELIGENTESEXAM1Label  matlab.ui.control.Label
        TurnOffButton                  matlab.ui.control.Button
        RGBAnalisisButton              matlab.ui.control.Button
        UIAxes                         matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        cam; % Description
        Continue % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: TurnOnButton
        function TurnOnButtonPushed(app, event)
            app.cam = webcam;
            app.Continue = true;
            
            while app.Continue
                img = snapshot(app.cam);
                imshow(img,'parent',app.UIAxes)
                pause(0.1)
            end
            
        end

        % Button pushed function: LaplaceFilterButton
        function LaplaceFilterButtonPushed(app, event)
            
            while 1
                app.cam = webcam;
                img = snapshot(app.cam);     
                img = im2gray(img);
                img = im2double(img);
                mask = 1 * ones(3,3);
                mask(2,2) = -8;
                filter = conv2(img,mask,'valid');
                axis(app.UIAxes,'image');
                imshow(filter, 'parent',app.UIAxes);
             
                pause(0.1);
            end
        end

        % Button down function: UIAxes
        function UIAxesButtonDown(app, event)
            
        end

        % Button pushed function: TurnOffButton
        function TurnOffButtonPushed(app, event)
            delete(app);
        end

        % Button pushed function: LinealFilterButton
        function LinealFilterButtonPushed(app, event)
            
            while 1
                app.cam = webcam;
                img = snapshot(app.cam);     
                img = im2gray(img);
                img = im2double(img);
                mask2 = 1/48 * ones(5,5);
                filter = conv2(img, mask2, 'same');
                axis(app.UIAxes,'image');
                imshow(filter, 'parent',app.UIAxes);
                pause(0.1);
            end
            
            
        end

        % Button pushed function: LowPassButton
        function LowPassButtonPushed(app, event)
            
            while 1
                app.cam = webcam;
                img = snapshot(app.cam);     
                img = im2gray(img);
                img = im2double(img);
                [M,N] = size(img);
                FT_img = fft2(double(img));
                D0 = 30; 
                u = 0:(M-1);
                idx = find(u>M/2);
                u(idx) = u(idx)-M;
                v = 0:(N-1);
                idy = find(v>N/2);
                v(idy) = v(idy)-N;
                [V, U] = meshgrid(v, u);
                D = sqrt(U.^2+V.^2);
                H = double(D <= D0);
                G = H.*FT_img;
                filter = real(ifft2(double(G)));
                axis(app.UIAxes,'image');
                imshow(filter, 'parent',app.UIAxes);
                pause(0.1)
            end
        end

        % Button pushed function: HighPassButton
        function HighPassButtonPushed(app, event)
            
            while 1
                app.cam = webcam;
                img = snapshot(app.cam);     
                img = im2gray(img);
                img = im2double(img);
                [M,N] = size(img);
                FT_img = fft2(double(img));
                D0 = 10;
                u = 0:(M-1);
                idx = find(u>M/2);
                u(idx) = u(idx)-M;
                v = 0:(N-1);
                idy = find(v>N/2);
                v(idy) = v(idy)-N;
                
                [V,U] = meshgrid(v,u);
                D = sqrt(U.^2+V.^2);
                H = double(D > D0);
                G = H.*FT_img;
                filter = real(ifft2(double(G)));
                axis(app.UIAxes,'image');
                imshow(filter, 'parent',app.UIAxes);
                pause(0.1)
            end
        end

        % Button pushed function: RGBAnalisisButton
        function RGBAnalisisButtonPushed(app, event)
             while 1
                app.cam = webcam;
                img = snapshot(app.cam);     
                img = im2double(img);
                img_blue = img(:,:,3); %Blue Layer
                img_green = img(:,:,2); %Green Layer
                img_red = img(:,:,1); %Red Layer
                allRed = sum(img_red,'all');
                allGreen = sum(img_green,'all');
                allBlue = sum(img_blue,'all');
                colorArray = [allRed,allGreen,allBlue];
                [M,N] = max(colorArray);
                black_img = zeros(size(img, 1), size(img, 2), 'double');
                
                img_red = cat(3, img_red, black_img, black_img);
                img_green = cat(3, black_img, img_green, black_img);
                img_blue = cat(3, black_img, black_img, img_blue);
                
                if N == 1
                    img_red = (img_red.^3);
                    color = "rojo";
                end
                
                if N == 2
                    img_green = (img_green.^3);
                    color = "verde";
                end
                
                if N == 3
                    img_blue = (img_blue.^3);
                    color = "azul";
                    
                end
                
                disp(color);
                
                recombinedRGBimage =  img_red + img_green + img_blue;
                imshow(recombinedRGBimage,'parent',app.UIAxes);
                pause(0.1)
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.1294 0.3059 0.4196];
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TurnOnButton
            app.TurnOnButton = uibutton(app.UIFigure, 'push');
            app.TurnOnButton.ButtonPushedFcn = createCallbackFcn(app, @TurnOnButtonPushed, true);
            app.TurnOnButton.Position = [54 330 100 22];
            app.TurnOnButton.Text = 'Turn On';

            % Create LinealFilterButton
            app.LinealFilterButton = uibutton(app.UIFigure, 'push');
            app.LinealFilterButton.ButtonPushedFcn = createCallbackFcn(app, @LinealFilterButtonPushed, true);
            app.LinealFilterButton.Position = [54 290 100 22];
            app.LinealFilterButton.Text = 'Lineal Filter';

            % Create LaplaceFilterButton
            app.LaplaceFilterButton = uibutton(app.UIFigure, 'push');
            app.LaplaceFilterButton.ButtonPushedFcn = createCallbackFcn(app, @LaplaceFilterButtonPushed, true);
            app.LaplaceFilterButton.Position = [54 250 100 22];
            app.LaplaceFilterButton.Text = 'Laplace Filter';

            % Create LowPassButton
            app.LowPassButton = uibutton(app.UIFigure, 'push');
            app.LowPassButton.ButtonPushedFcn = createCallbackFcn(app, @LowPassButtonPushed, true);
            app.LowPassButton.Position = [54 210 100 22];
            app.LowPassButton.Text = 'Low Pass';

            % Create HighPassButton
            app.HighPassButton = uibutton(app.UIFigure, 'push');
            app.HighPassButton.ButtonPushedFcn = createCallbackFcn(app, @HighPassButtonPushed, true);
            app.HighPassButton.Position = [54 170 100 22];
            app.HighPassButton.Text = 'High Pass';

            % Create AGENTESINTELIGENTESEXAM1Label
            app.AGENTESINTELIGENTESEXAM1Label = uilabel(app.UIFigure);
            app.AGENTESINTELIGENTESEXAM1Label.HorizontalAlignment = 'center';
            app.AGENTESINTELIGENTESEXAM1Label.FontSize = 26;
            app.AGENTESINTELIGENTESEXAM1Label.Position = [103 424 435 33];
            app.AGENTESINTELIGENTESEXAM1Label.Text = 'AGENTES INTELIGENTES EXAM 1';

            % Create TurnOffButton
            app.TurnOffButton = uibutton(app.UIFigure, 'push');
            app.TurnOffButton.ButtonPushedFcn = createCallbackFcn(app, @TurnOffButtonPushed, true);
            app.TurnOffButton.Position = [54 90 100 22];
            app.TurnOffButton.Text = 'Turn Off';

            % Create RGBAnalisisButton
            app.RGBAnalisisButton = uibutton(app.UIFigure, 'push');
            app.RGBAnalisisButton.ButtonPushedFcn = createCallbackFcn(app, @RGBAnalisisButtonPushed, true);
            app.RGBAnalisisButton.Position = [54 130 100 22];
            app.RGBAnalisisButton.Text = 'RGB Analisis';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.ButtonDownFcn = createCallbackFcn(app, @UIAxesButtonDown, true);
            app.UIAxes.Position = [199 17 412 408];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = WebCamPractice_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end