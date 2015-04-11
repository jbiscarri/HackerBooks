#import "Annotation.h"

@interface Annotation ()

// Private interface goes here.

@end

@implementation Annotation

#pragma mark - Class methods
+(NSArray*)observableKeys{
    
    return @[AnnotationAttributes.text, AnnotationRelationships.photo, AnnotationRelationships.book, AnnotationRelationships.localization];
}

#pragma mark - Life cycle
-(void) awakeFromInsert{
    [super awakeFromInsert];
    [self setupKVO];
}

-(void) awakeFromFetch{
    [super awakeFromFetch];
    [self setupKVO];
}

-(void) willTurnIntoFault{
    [super willTurnIntoFault];
    [self tearDownKVO];
}

#pragma mark - KVO
-(void) setupKVO{
    for (NSString *key in [[self class] observableKeys]) {
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:NULL];
        
    }
}

-(void) tearDownKVO{
    // me doy de baja de todas las notificaciones
    for (NSString *key in [[self class] observableKeys]) {
        [self removeObserver:self
                  forKeyPath:key];
    }
}

#pragma mark - modification date

#pragma mark - KVO
-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    self.modificationDate = [NSDate date];
}

@end
