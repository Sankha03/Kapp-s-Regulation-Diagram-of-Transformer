classdef KappGUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        Panel_2                        matlab.ui.container.Panel
        Panel_4                        matlab.ui.container.Panel
        jEditField_2                   matlab.ui.control.NumericEditField
        jEditField                     matlab.ui.control.NumericEditField
        jLabel                         matlab.ui.control.Label
        ButtonGroup                    matlab.ui.container.ButtonGroup
        RjXButton                      matlab.ui.control.RadioButton
        kVAPowerFactorButton           matlab.ui.control.RadioButton
        AmountofLoadkVAEditFieldLabel_2  matlab.ui.control.Label
        EditFieldLabel_3               matlab.ui.control.Label
        EditFieldLabel_2               matlab.ui.control.Label
        PercentageVoltageRegulationEditField  matlab.ui.control.NumericEditField
        PercentageVoltageRegulationEditFieldLabel  matlab.ui.control.Label
        CalculateButton                matlab.ui.control.Button
        EquivalentReactanceRefferedtosecondarySideX_02OhmEditField  matlab.ui.control.NumericEditField
        EquivalentWindingReactanceRefferedtosecondarySideX_02OhmLabel  matlab.ui.control.Label
        EquivalentResistanceRefferedtosecondarySideR_02OhmEditField  matlab.ui.control.NumericEditField
        EditFieldLabel                 matlab.ui.control.Label
        TurnsRation1EditField          matlab.ui.control.NumericEditField
        TurnsRation1EditFieldLabel     matlab.ui.control.Label
        PrimaryVoltageVEditField       matlab.ui.control.NumericEditField
        PrimaryVoltageVEditFieldLabel  matlab.ui.control.Label
        Panel_3                        matlab.ui.container.Panel
        PowerFactorPutForLeadingEditField  matlab.ui.control.NumericEditField
        PowerFactorPutForLeadingLabel  matlab.ui.control.Label
        kVAEditField                   matlab.ui.control.NumericEditField
        kVAEditFieldLabel              matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
           v1=app.PrimaryVoltageVEditField.Value;
           n=app.TurnsRation1EditField.Value;
           R02=app.EquivalentResistanceRefferedtosecondarySideR_02OhmEditField.Value;
           X02=app.EquivalentReactanceRefferedtosecondarySideX_02OhmEditField.Value;
           v2=v1/n;

           if (app.kVAPowerFactorButton.Value)
               z=1000*app.kVAEditField.Value;
               pf=app.PowerFactorPutForLeadingEditField.Value;
               ph=acos(pf);
               I=z/v2;
               VR=I*(R02*cos(ph)+X02*sin(ph))/v2*100;
               V2=v2*exp(i*ph);
           end
           if(app.RjXButton.Value)
               Z1=sqrt(app.jEditField_2.Value^2+app.jEditField.Value^2);
               Phi=atan(app.jEditField.Value/app.jEditField_2.Value);
               Z=Z1*exp(i*Phi);
               Req=R02+app.jEditField_2.Value;
               Xeq=X02+app.jEditField.Value;
               Z2=sqrt(Req^2+Xeq^2);
               ph=atan(Xeq/Req);
               Zeq=Z2*exp(i*ph);
               I2=(v2/Zeq);
               I=abs(I2);
               v22=abs(I2*Z);
               VR=((v2-v22)/v2)*100;
               V2=v22*exp(i*ph);
           end
           
           app.PercentageVoltageRegulationEditField.Value=VR;
           E2=V2+I*(R02+i*X02);
           polarplot([0;0],[0;1.5*abs(E2)],'->')        
           title("Kapp's Voltage Regulation Diagram:");
           subtitle("\color{Magenta}Magenta===Terminal Volatage Circle           \color{Blue}Blue ==Open Circuit EMF Circle")           
           hold on
           polarplot([0; ph],[0;v2],'->',LineWidth=1)
           polarplot([ph;angle(V2+I*R02)],[v2; abs(V2+I*R02)],'->',LineWidth=1)
           polarplot([angle(V2+I*R02);angle(E2)],[abs(V2+I*R02);abs(E2)],'->',LineWidth=1)
           polarplot([0;angle(E2)],[0;abs(E2)],'->',LineWidth=1)
           th=(linspace(0,2*pi,100))';
           p1=polarplot( th,abs(E2)+zeros(size(th)),'b',LineWidth=1);
           polarplot([0;3*pi/2],[0;I*X02],'->',LineWidth=1)
           polarplot([3*pi/2;angle(-I*(R02+i*X02))],[I*X02;abs(-I*(R02+i*X02))],'->',LineWidth=1)
           polarplot([0;angle(-I*(R02+i*X02))],[0;abs(-I*(R02+i*X02))],'->',LineWidth=1)
           polarplot([angle(-I*(R02+i*X02));ph],[abs(-I*(R02+i*X02));v2],'k--',LineWidth=1)
           Cx = -I*R02;
           Cy = -I*X02;
           r = abs(E2);
           x = r*cos(th) + Cx;
           y = r*sin(th) + Cy;
           [theta,rho] = cart2pol(x,y);
           polarplot( theta,rho,'m-.',LineWidth=1);
           text(ph,v2,'V_2','Color','k');
           text(0,0,'O','Color','k');
           text(angle(-I*(R02+i*X02)),abs(-I*(R02+i*X02)),"O'",'Color','k');
           text(0,1.5*abs(E2),'I_2','Color','k');
           text(angle(E2),abs(E2),'E_2','Color','k');          
           hold off
        end

        % Selection changed function: ButtonGroup
        function ButtonGroupSelectionChanged(app, event)
            if (app.RjXButton.Value)
               app.Panel_4.Visible='on';
               app.Panel_3.Visible='off';
            end
            if (app.kVAPowerFactorButton.Value)
               app.Panel_3.Visible='on';
               app.Panel_4.Visible='off';
            end 
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.4588 0.4902 0.902];
            app.UIFigure.Position = [100 100 469 687];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Resize = 'off';

            % Create Panel_2
            app.Panel_2 = uipanel(app.UIFigure);
            app.Panel_2.BackgroundColor = [0.8549 0.9059 0.9098];
            app.Panel_2.Position = [25 38 422 623];

            % Create Panel_3
            app.Panel_3 = uipanel(app.Panel_2);
            app.Panel_3.BorderType = 'none';
            app.Panel_3.BackgroundColor = [0.8549 0.9059 0.9098];
            app.Panel_3.Position = [40 162 352 69];

            % Create kVAEditFieldLabel
            app.kVAEditFieldLabel = uilabel(app.Panel_3);
            app.kVAEditFieldLabel.HorizontalAlignment = 'right';
            app.kVAEditFieldLabel.FontName = 'Maiandra GD';
            app.kVAEditFieldLabel.FontSize = 16;
            app.kVAEditFieldLabel.FontWeight = 'bold';
            app.kVAEditFieldLabel.Position = [3 31 35 22];
            app.kVAEditFieldLabel.Text = 'kVA';

            % Create kVAEditField
            app.kVAEditField = uieditfield(app.Panel_3, 'numeric');
            app.kVAEditField.HorizontalAlignment = 'center';
            app.kVAEditField.FontName = 'Bookman';
            app.kVAEditField.FontSize = 16;
            app.kVAEditField.Position = [53 27 49 30];

            % Create PowerFactorPutForLeadingLabel
            app.PowerFactorPutForLeadingLabel = uilabel(app.Panel_3);
            app.PowerFactorPutForLeadingLabel.HorizontalAlignment = 'center';
            app.PowerFactorPutForLeadingLabel.WordWrap = 'on';
            app.PowerFactorPutForLeadingLabel.FontName = 'Maiandra GD';
            app.PowerFactorPutForLeadingLabel.FontSize = 16;
            app.PowerFactorPutForLeadingLabel.FontWeight = 'bold';
            app.PowerFactorPutForLeadingLabel.Position = [142 12 139 60];
            app.PowerFactorPutForLeadingLabel.Text = 'Power Factor           (Put ''-''For Leading)';

            % Create PowerFactorPutForLeadingEditField
            app.PowerFactorPutForLeadingEditField = uieditfield(app.Panel_3, 'numeric');
            app.PowerFactorPutForLeadingEditField.HorizontalAlignment = 'center';
            app.PowerFactorPutForLeadingEditField.FontName = 'Bookman';
            app.PowerFactorPutForLeadingEditField.FontSize = 16;
            app.PowerFactorPutForLeadingEditField.Position = [293 29 44 30];

            % Create PrimaryVoltageVEditFieldLabel
            app.PrimaryVoltageVEditFieldLabel = uilabel(app.Panel_2);
            app.PrimaryVoltageVEditFieldLabel.HorizontalAlignment = 'right';
            app.PrimaryVoltageVEditFieldLabel.FontName = 'Maiandra GD';
            app.PrimaryVoltageVEditFieldLabel.FontSize = 16;
            app.PrimaryVoltageVEditFieldLabel.FontWeight = 'bold';
            app.PrimaryVoltageVEditFieldLabel.Position = [51 564 148 22];
            app.PrimaryVoltageVEditFieldLabel.Text = 'Primary Voltage (V)';

            % Create PrimaryVoltageVEditField
            app.PrimaryVoltageVEditField = uieditfield(app.Panel_2, 'numeric');
            app.PrimaryVoltageVEditField.HorizontalAlignment = 'center';
            app.PrimaryVoltageVEditField.FontName = 'Bookman';
            app.PrimaryVoltageVEditField.FontSize = 16;
            app.PrimaryVoltageVEditField.Position = [214 560 49 30];

            % Create TurnsRation1EditFieldLabel
            app.TurnsRation1EditFieldLabel = uilabel(app.Panel_2);
            app.TurnsRation1EditFieldLabel.HorizontalAlignment = 'right';
            app.TurnsRation1EditFieldLabel.FontName = 'Maiandra GD';
            app.TurnsRation1EditFieldLabel.FontSize = 16;
            app.TurnsRation1EditFieldLabel.FontWeight = 'bold';
            app.TurnsRation1EditFieldLabel.Position = [51 493 124 22];
            app.TurnsRation1EditFieldLabel.Text = 'Turns Ratio(n:1) ';

            % Create TurnsRation1EditField
            app.TurnsRation1EditField = uieditfield(app.Panel_2, 'numeric');
            app.TurnsRation1EditField.HorizontalAlignment = 'center';
            app.TurnsRation1EditField.FontName = 'Bookman';
            app.TurnsRation1EditField.FontSize = 16;
            app.TurnsRation1EditField.Position = [190 489 49 30];

            % Create EditFieldLabel
            app.EditFieldLabel = uilabel(app.Panel_2);
            app.EditFieldLabel.WordWrap = 'on';
            app.EditFieldLabel.FontName = 'Maiandra GD';
            app.EditFieldLabel.FontSize = 16;
            app.EditFieldLabel.FontWeight = 'bold';
            app.EditFieldLabel.Position = [51 390 288 58];
            app.EditFieldLabel.Text = 'Equivalent Winding Resistance Reffered to secondary Side (R   ) (Ohm)';

            % Create EquivalentResistanceRefferedtosecondarySideR_02OhmEditField
            app.EquivalentResistanceRefferedtosecondarySideR_02OhmEditField = uieditfield(app.Panel_2, 'numeric');
            app.EquivalentResistanceRefferedtosecondarySideR_02OhmEditField.HorizontalAlignment = 'center';
            app.EquivalentResistanceRefferedtosecondarySideR_02OhmEditField.FontName = 'Bookman';
            app.EquivalentResistanceRefferedtosecondarySideR_02OhmEditField.FontSize = 16;
            app.EquivalentResistanceRefferedtosecondarySideR_02OhmEditField.Position = [353 404 49 30];

            % Create EquivalentWindingReactanceRefferedtosecondarySideX_02OhmLabel
            app.EquivalentWindingReactanceRefferedtosecondarySideX_02OhmLabel = uilabel(app.Panel_2);
            app.EquivalentWindingReactanceRefferedtosecondarySideX_02OhmLabel.WordWrap = 'on';
            app.EquivalentWindingReactanceRefferedtosecondarySideX_02OhmLabel.FontName = 'Maiandra GD';
            app.EquivalentWindingReactanceRefferedtosecondarySideX_02OhmLabel.FontSize = 16;
            app.EquivalentWindingReactanceRefferedtosecondarySideX_02OhmLabel.FontWeight = 'bold';
            app.EquivalentWindingReactanceRefferedtosecondarySideX_02OhmLabel.Position = [51 291 288 58];
            app.EquivalentWindingReactanceRefferedtosecondarySideX_02OhmLabel.Text = 'Equivalent Winding Reactance Reffered to secondary Side(X   ) (Ohm)';

            % Create EquivalentReactanceRefferedtosecondarySideX_02OhmEditField
            app.EquivalentReactanceRefferedtosecondarySideX_02OhmEditField = uieditfield(app.Panel_2, 'numeric');
            app.EquivalentReactanceRefferedtosecondarySideX_02OhmEditField.HorizontalAlignment = 'center';
            app.EquivalentReactanceRefferedtosecondarySideX_02OhmEditField.FontName = 'Bookman';
            app.EquivalentReactanceRefferedtosecondarySideX_02OhmEditField.FontSize = 16;
            app.EquivalentReactanceRefferedtosecondarySideX_02OhmEditField.Position = [353 305 49 30];

            % Create CalculateButton
            app.CalculateButton = uibutton(app.Panel_2, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.BackgroundColor = [0.4275 0.9686 0.6];
            app.CalculateButton.FontName = 'Bahnschrift';
            app.CalculateButton.FontSize = 16;
            app.CalculateButton.FontWeight = 'bold';
            app.CalculateButton.FontColor = [0.149 0.149 0.149];
            app.CalculateButton.Position = [157 85 111 40];
            app.CalculateButton.Text = 'Calculate';

            % Create PercentageVoltageRegulationEditFieldLabel
            app.PercentageVoltageRegulationEditFieldLabel = uilabel(app.Panel_2);
            app.PercentageVoltageRegulationEditFieldLabel.HorizontalAlignment = 'right';
            app.PercentageVoltageRegulationEditFieldLabel.FontName = 'Maiandra GD';
            app.PercentageVoltageRegulationEditFieldLabel.FontSize = 16;
            app.PercentageVoltageRegulationEditFieldLabel.FontWeight = 'bold';
            app.PercentageVoltageRegulationEditFieldLabel.Position = [40 33 254 22];
            app.PercentageVoltageRegulationEditFieldLabel.Text = 'Percentage Voltage Regulation(%)';

            % Create PercentageVoltageRegulationEditField
            app.PercentageVoltageRegulationEditField = uieditfield(app.Panel_2, 'numeric');
            app.PercentageVoltageRegulationEditField.Editable = 'off';
            app.PercentageVoltageRegulationEditField.HorizontalAlignment = 'center';
            app.PercentageVoltageRegulationEditField.FontName = 'Bookman';
            app.PercentageVoltageRegulationEditField.FontSize = 16;
            app.PercentageVoltageRegulationEditField.Position = [302 27 49 30];

            % Create EditFieldLabel_2
            app.EditFieldLabel_2 = uilabel(app.Panel_2);
            app.EditFieldLabel_2.WordWrap = 'on';
            app.EditFieldLabel_2.FontName = 'Maiandra GD';
            app.EditFieldLabel_2.FontSize = 10;
            app.EditFieldLabel_2.FontWeight = 'bold';
            app.EditFieldLabel_2.Position = [199 397 13 15];
            app.EditFieldLabel_2.Text = '02';

            % Create EditFieldLabel_3
            app.EditFieldLabel_3 = uilabel(app.Panel_2);
            app.EditFieldLabel_3.WordWrap = 'on';
            app.EditFieldLabel_3.FontName = 'Maiandra GD';
            app.EditFieldLabel_3.FontSize = 10;
            app.EditFieldLabel_3.FontWeight = 'bold';
            app.EditFieldLabel_3.Position = [196 295 13 15];
            app.EditFieldLabel_3.Text = '02';

            % Create AmountofLoadkVAEditFieldLabel_2
            app.AmountofLoadkVAEditFieldLabel_2 = uilabel(app.Panel_2);
            app.AmountofLoadkVAEditFieldLabel_2.HorizontalAlignment = 'right';
            app.AmountofLoadkVAEditFieldLabel_2.FontName = 'Maiandra GD';
            app.AmountofLoadkVAEditFieldLabel_2.FontSize = 16;
            app.AmountofLoadkVAEditFieldLabel_2.FontWeight = 'bold';
            app.AmountofLoadkVAEditFieldLabel_2.Position = [35 260 175 22];
            app.AmountofLoadkVAEditFieldLabel_2.Text = 'Amount of Load (kVA):';

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.Panel_2);
            app.ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);
            app.ButtonGroup.ForegroundColor = [1 1 1];
            app.ButtonGroup.BorderType = 'none';
            app.ButtonGroup.TitlePosition = 'centertop';
            app.ButtonGroup.BackgroundColor = [0.851 0.9098 0.9098];
            app.ButtonGroup.FontSize = 14;
            app.ButtonGroup.Position = [214 246 207 36];

            % Create kVAPowerFactorButton
            app.kVAPowerFactorButton = uiradiobutton(app.ButtonGroup);
            app.kVAPowerFactorButton.Text = 'kVA & Power Factor';
            app.kVAPowerFactorButton.FontName = 'Maiandra GD';
            app.kVAPowerFactorButton.FontWeight = 'bold';
            app.kVAPowerFactorButton.Position = [11 14 131 22];
            app.kVAPowerFactorButton.Value = true;

            % Create RjXButton
            app.RjXButton = uiradiobutton(app.ButtonGroup);
            app.RjXButton.Text = 'R+jX';
            app.RjXButton.FontName = 'Maiandra GD';
            app.RjXButton.FontWeight = 'bold';
            app.RjXButton.Position = [146 13 65 22];

            % Create Panel_4
            app.Panel_4 = uipanel(app.Panel_2);
            app.Panel_4.BorderType = 'none';
            app.Panel_4.Visible = 'off';
            app.Panel_4.BackgroundColor = [0.8549 0.9059 0.9098];
            app.Panel_4.Position = [35 179 165 54];

            % Create jLabel
            app.jLabel = uilabel(app.Panel_4);
            app.jLabel.HorizontalAlignment = 'center';
            app.jLabel.FontName = 'Maiandra GD';
            app.jLabel.FontSize = 16;
            app.jLabel.FontWeight = 'bold';
            app.jLabel.Position = [85 20 26 22];
            app.jLabel.Text = '+ j';

            % Create jEditField
            app.jEditField = uieditfield(app.Panel_4, 'numeric');
            app.jEditField.HorizontalAlignment = 'center';
            app.jEditField.FontName = 'Bookman';
            app.jEditField.FontSize = 16;
            app.jEditField.Position = [110 13 49 30];

            % Create jEditField_2
            app.jEditField_2 = uieditfield(app.Panel_4, 'numeric');
            app.jEditField_2.HorizontalAlignment = 'center';
            app.jEditField_2.FontName = 'Bookman';
            app.jEditField_2.FontSize = 16;
            app.jEditField_2.Position = [38 13 48 30];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = KappGUI

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