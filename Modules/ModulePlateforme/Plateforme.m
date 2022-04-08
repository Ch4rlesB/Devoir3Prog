classdef Plateforme < handle
%
% La classe Plateforme représente la plateforme de gestion des transactions
% que vous avez développée. Elle hérite de la classe handle. Elle 
% possède les attributs suivants qui sont des attributs privés à moins 
% d’indication contraire : 
%
% PROPRIETES :
% - nbBanques : Un double qui correspond au nombre de banques contenues
%   dans la plateforme. La valeur par défaut est zéro. 
% - tabBanques = Un tableau de type Banque qui doit être initialisé avec le
%   bon type, mais vide. Il s'agit des références vers les banques
%   contenues dans la plateforme.
%
% MUTATEURS :
% - getNbBanques : Retourne le double correspondant au nombre de banques
%   contenues.
%   
%
    properties (Access=private)
       nbBanques = 0;
       tabBanques = Banque.empty();
    end

    methods (Access = public)
        function nouvellePlatforme = Plateforme()
        %
        % Cette fonction est le constructeur de l'objet Plateforme.
        % Elle charge la base de donnée à l'aide de ChargerBaseDeDonnees()
        %
        % PARAMÈTRES :
        % AUCUN
        %
        % VALEUR DE RETOUR : La nouvelle plateforme (type Plateforme)
        % 
            %Charge la base de donnée
            nouvellePlatforme.ChargerBaseDeDonnees();
        end

        function retour = getNbBanques(plateforme)
            %Retourne nbBanques
            retour = plateforme.nbBanques;
        end

        function AnalyserJournalTransactions(plateforme,nomFichier)
        %
        % Méthode qui lit, analyse et lance l exécution des transactions à
        % partir d un journal de transactions en format texte. 
        % Elle prend les entrées suivantes :
        %
        % PARAMÈTRES :
        % - plateforme : Objet plateforme de reference. (type Plateforme)
        % - nomFichier[] : Une chaîne de caractères qui correspond au nom 
        %   du fichier texte qui contient le journal de transactions.
        %   (type char)
        %
        % VALEUR DE RETOUR : 
        %   RIEN
        %   
            %Valide que nomFichier est une chaine de caractère et importe
            %les constantes nécéssaires pour ouvrir le fichier au nom
            %nomFichier
            validateattributes(nomFichier, {'char'},{'scalartext'});
            ImporterConstantes;
            noFichier = fopen([CHEMIN_DONNEES,'\',nomFichier]);
            assert(noFichier ~= -1,'Erreur d''ouverture de fichier.');
            
            %Decortique chaque ligne du journal de transaction et séprare
            %la ligne en les différentes valeurs utiles
            while ~feof(noFichier)
                donnees = fscanf(noFichier,'%c%c%c,%c,%g,%c,%g\n',7);
                noInst = char.empty();
                noInst = [char(donnees(1)),char(donnees(2)),char(donnees(3))];
                typeTrans = char(donnees(4));
                idCompte = donnees(5);
                typeCompte = char(donnees(6));
                montant = donnees(7);
                EffectuerTransaction(plateforme, noInst,typeTrans,idCompte,typeCompte,montant);
            end

        end
        function GenererRapport(ref,nomFichier)
        %
        % Méthode qui génère un rapport détaillé à partir de la base de 
        % données. . Une référence vous a été fournie pour déterminer le
        % format de ce dernier. Elle prend les entrées suivantes :
        %
        % PARAMÈTRES :
        % - ref : Objet plateforme de reference. (type Plateforme)
        % - nomFichier[] : Une chaîne de caractères qui correspond au nom 
        %   du fichier texte qui contient le rapport.(type char)
        %
        % VALEUR DE RETOUR : 
        %   RIEN
        %   
            %Rajoute '.txt' a la fin de nomFichier si celui-ci est manquant
            if ~strcmp(nomFichier(end-3:end),'.txt')
                nomFichier = [nomFichier,'.txt'];
            end

            %Importe les constantes nécéssaires pour ouvrir le fichier au nom
            %nomFichier
            ImporterConstantes;
            noFichier = fopen([CHEMIN_RAPPORTS,'\',nomFichier],'w');
            assert(noFichier ~= -1,'Erreur d''ouverture de fichier.');
            
            %Écrit l'information demandée dans le rapport.
            for i=1:size(ref.tabBanques, 2)
                fprintf(noFichier,'Banque No. %g\n\n',i);
                fprintf(noFichier,'	Nom               : %s\n',ref.tabBanques(i).getNom());
                fprintf(noFichier,'	No. institution   : %s\n',ref.tabBanques(i).getNumero());
                fprintf(noFichier,'	Nombre de clients : %g\n',ref.tabBanques(i).getNbClient());
                fprintf(noFichier,'	Nombre de comptes : %g\n\n',ref.tabBanques(i).getNbCompte());
                fprintf(noFichier,'\tDétails des comptes clients :\n\n');

                for j=1:ref.tabBanques(i).getNbClient()
                    fprintf(noFichier,'		Client No. %g\n\n',j);
                    fprintf(noFichier,'			Prénom : %s\n', ref.tabBanques(i).ObtenirClient(j).getPrenom());
                    fprintf(noFichier,'			Nom     : %s\n\n', ref.tabBanques(i).ObtenirClient(j).getNom());
                    totalCheques = 0;
                    totalEpargne = 0;
                    for k=1:ref.tabBanques(i).ObtenirClient(j).getNbComptes()
                        fprintf(noFichier,'\t\t\t\tCompte No. %g\n\n',k);
                        fprintf(noFichier,'					Identifiant    : %s\n',ref.tabBanques(i).ObtenirClient(j).ObtenirCompte(k).getIdentifiant());
                        soldeCheque = TransformerFormatBancaire(ref.tabBanques(i).ObtenirClient(j).ObtenirCompte(k).getSoldeCheque());
                        totalCheques = totalCheques + ref.tabBanques(i).ObtenirClient(j).ObtenirCompte(k).getSoldeCheque();
                        soldeEpargne = TransformerFormatBancaire(ref.tabBanques(i).ObtenirClient(j).ObtenirCompte(k).getSoldeEpargne());
                        totalEpargne = totalEpargne + ref.tabBanques(i).ObtenirClient(j).ObtenirCompte(k).getSoldeEpargne();
                        fprintf(noFichier,'					Solde cheques  : %s\n',soldeCheque);
                        fprintf(noFichier,'					Solde epargnes : %s\n\n',soldeEpargne);
                    end
                    fprintf(noFichier,'			Total cheques : %s\n',TransformerFormatBancaire(totalCheques));
                    fprintf(noFichier,'			Total epargne : %s\n\n',TransformerFormatBancaire(totalEpargne));
                end
            end
        fclose(noFichier); 
        end
        
        function EffectuerTransaction(ref,numInst,typeTrans,id,typeCompte,montant)
        %
        % Méthode effectue une transaction sur un compte donné. Elle prend 
        % les entrées suivantes :
        %
        % PARAMÈTRES :
        % - ref : Objet plateforme de reference. (type Plateforme)
        % - numInst[] : Une chaîne de caractères qui correspond au 
        %   numéro d’institution de la banque.(type char)
        % - typeTrans : Un caractère qui correspond au type de la 
        %   transaction « R » ou « D » pour retrait et dépôt respectivement
        %   (type char)
        % - id[] : Une chaine de caractère qui correspond à l'identifiant 
        %   du compte. (type char)
        % - typeCompte[] : Une chaîne de caractères qui correspond au type
        %   du compte « C » ou « E » pour chèques et épargne respectivement
        %   (type char)
        % - montant : Double représantant le montant de la transaction
        %   (type double)
        %
        %
        % VALEUR DE RETOUR : 
        %   RIEN
        % 
            
            %Trouve l'indice de la banque correspondant au numInst
            i=1;
            while ~strcmp(ref.tabBanques(i).getNumero,(numInst))
                i= i+1;
            end
            %Effectue la transaction dépendant si le compte est Cheques ou
            %Épargne et effectue un depot ou un retrait
            if typeTrans == 'D'
                if typeCompte == 'C'
                    DepotCheques(ref.tabBanques(i).ObtenirCompteParIdentifiant(id),montant);
                elseif typeCompte == 'E'
                    DepotEpargne(ref.tabBanques(i).ObtenirCompteParIdentifiant(id),montant);
                end   
            elseif typeTrans == 'R'
                if typeCompte == 'C'
                    RetraitCheques(ref.tabBanques(i).ObtenirCompteParIdentifiant(id),montant);
                elseif typeCompte == 'E'
                    RetraitEpargne(ref.tabBanques(i).ObtenirCompteParIdentifiant(id),montant);
                end  
            end
        end


        function ChargerBaseDeDonnees(obj)
        %
        % Methode qui charge la base de donnees
        %
        % PARAMÈTRES :
        % - ref : Objet plateforme de reference. (type Plateforme)
        %
        % VALEUR DE RETOUR : 
        %   RIEN
        % 
        % 
	        
	        % Importer les constantes
	        ImporterConstantes
	        
	        % Fixer la semence aleatoire
	        rng(0)
	        
	        % Lire la base de donnees
	        FID = fopen(CHEMIN_BD, 'r');
	        texte = {};
	        while ~feof(FID)
		        texte{end + 1} = fgetl(FID); %#ok
	        end
	        fclose(FID);
	        
	        % Reconstruire la base de donnees
	        
	        % Le nombre de banques
	        temp = strsplit(texte{1}, ':');
	        nombreBanques = str2double(temp{end});
	        
	        % La ligne qui contient le nom de la banque
	        ligneNomBanque = 2;
	        
	        for i = 1 : nombreBanques
		        
		        % Nom de la banque
		        temp = strsplit(texte{ligneNomBanque}, ':');
		        nomBanque = strtrim(temp{end});
		        
		        % Numero d'institution de la banque
		        temp = strsplit(texte{ligneNomBanque + 1}, ':');
		        numeroInstitution = strtrim(temp{end});
		        
		        % Initialiser la banque
		        listeBanques(i) = Banque(nomBanque, numeroInstitution); %#ok
		        
		        % Le nombre de client de la banque
		        temp = strsplit(texte{ligneNomBanque + 2}, ':');
		        nbClients = str2double(temp{end});
		        
		        % La ligne qui contient le prÃ©nom du client
		        lignePrenomClient = ligneNomBanque + 5;
		        
		        for j = 1 : nbClients
			        
			        % Prenom du client
			        temp = strtrim(strsplit(texte{lignePrenomClient}, ':'));
			        prenom = temp{end};
			        
			        % Nom de famille du client
			        temp = strtrim(strsplit(texte{lignePrenomClient + 1}, ':'));
			        nom = temp{end};
			        
			        % Numero d'assurance sociale du client
			        temp = strtrim(strsplit(texte{lignePrenomClient + 2}, ':'));
			        numeroAssuranceSociale = temp{end};
			        
			        % Creer le client
			        unClient = Client(prenom, nom, numeroAssuranceSociale);
			        
			        % Nombre de comptes du client
			        temp = strsplit(texte{lignePrenomClient + 3}, ':');
			        nbComptes = str2double(temp{end});
			        
			        % La ligne qui contient le solde du comptes de cheques du client
			        ligneSoldeCheque = lignePrenomClient + 5;
			        
			        % Charger tous les comptes
			        for k = ligneSoldeCheque : 3 : ligneSoldeCheque + 3 * (nbComptes - 1)
				        
				        % Lire le solde du compte cheques
				        temp = strsplit(texte{k}, ':');
				        soldeCheque = str2double(temp{end});
				        
				        % Lire le solde du compte epargne
				        temp = strsplit(texte{k + 1}, ':');
				        soldeEpargne = str2double(temp{end});
				        
				        % Instancier le compte
				        unCompte = Compte(soldeCheque, soldeEpargne);
				        
				        % Le client est desormais le proprietaire du compte
				        %unCompte.proprietaire = unClient;
				        
				        % Ajouter le compte a la banque
				        listeBanques(i).AjouterCompte(unCompte, unClient);
				        
			        end
			        
			        % Ajouter le client a la banque
			        listeBanques(i).AjouterClient(unClient);
			        
			        % Ligne du prochain client
			        lignePrenomClient = k + 3;
			        
		        end
		        
		        % Ligne de la prochaine banque
		        ligneNomBanque = lignePrenomClient - 1;
		        
	        end
	        
	        % Enregistrer les parametres dans la plateforme
	        obj.nbBanques = nombreBanques;
	        obj.tabBanques = listeBanques;
	         
        end
        
    end    
end