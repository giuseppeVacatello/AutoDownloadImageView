//
//  AutoDownloadImageView.h
//  ImageViewAutoDownload
//
//  Created by Ignazio Calò on 10/1/11.
//  Copyright 2011 Ignazio Calò. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AutoDownloadImageViewErrorDomain      @"AutoDownloadImageView Error Domain"
enum 
{
	AutoDownloadImageViewErrorNoConnection = 0x1000
};

@class AutoDownloadImageView;
/**
 * Questo è il protocollo che dovrà implementare la classe che utilizza
 * oggetti di tipo AutoDownloadImageView contiene due metodi utili per eseguire
 * ad esempio un refresh dell'interfaccia
 */
@protocol AutoDownloadImageViewDelegate
/**
 * Il download è completato con successo. Il ricevente può implementare questo metodo
 * eseguendo un refresh dello schermo.
 */
- (void)autoDownloadImageViewFinishDownloading:(AutoDownloadImageView *)autoDowload;

/**
 * Il download è terminato con un errore, Il ricevente può eseguire l'operazione che 
 * ritiene opportuna.
 */
- (void)autoDownload:(AutoDownloadImageView *)autoDowload didFailWithError:(NSError *)error;
@end


@interface AutoDownloadImageView : UIImageView {
	/**
	 * La url dal quale scaricare l'immagine
	 */
	NSURL *imageURL;
	
	/**
	 * il delegate al quale verranno inviati i messaggi
	 */
	id <NSObject, AutoDownloadImageViewDelegate>  delegate;
	
	/**
	 * Un buffer dove memorizzare i dati scaricati da internet
	 */
	NSMutableData *receivedData;
	
	/**
	 * Se questa variabile è settata a TRUE l'immagine scaricata
	 * viene memorizzata nella cartella Documents dell'applicazione
	 * viceversa l'immagine viene cancellata.
	 */
	BOOL persistency;
	
	/**
	 * Se questa variabile è settata a TRUE viene sempre tentato il dowload
	 * dell'immagine da internet, viceversa viene cercata un'immagine con lo stesso
	 * nome nella cartella Documents dell'applicazione
	 * Questo sistema di confronto è piuttosto debole, bisognerebbe aggiungere 
	 * della logica per gestire due file con lo stesso nome
	 */
	BOOL forceDownload;
	
	
	
	/**
	 * Il nome del file
	 */
	NSString *filename;
}


@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, assign) id <NSObject, AutoDownloadImageViewDelegate> delegate;

/**
 * Questo è l'unico metodo init utilizzabile, imposta le variabili corrette ed esegue il download
 */
-(id)initWithFrame:(CGRect)frame URL:(NSURL *)url persistency:(BOOL)persist forceDownload:(BOOL)force;

/**
 * Fa partire il download, non usare esplicitamente
 */
-(void)startDownload;
@end
