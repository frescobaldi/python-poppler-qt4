namespace Poppler {

class AnnotationUtils {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    static Poppler::Annotation * createAnnotation( const QDomElement & annElement );
    static void storeAnnotation( const Poppler::Annotation * ann,
        QDomElement & annElement, QDomDocument & document );
    static QDomElement findChildElement( const QDomNode & parentNode,
        const QString & name );
}; // class AnnotationUtils


class Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    enum SubType { AText = 1, ALine = 2, AGeom = 3, AHighlight = 4, AStamp = 5,
                   AInk = 6, ALink = 7, ACaret = 8, AFileAttachment = 9, ASound = 10,
                   AMovie = 11, A_BASE = 0 };
    enum Flag { Hidden = 1, FixedSize = 2, FixedRotation = 4, DenyPrint = 8,
                DenyWrite = 16, DenyDelete = 32, ToggleHidingOnMouse = 64, External = 128 };
    enum LineStyle { Solid = 1, Dashed = 2, Beveled = 4, Inset = 8, Underline = 16 };
    enum LineEffect { NoEffect = 1, Cloudy = 2};
    enum RevScope { Reply = 1, Group = 2, Delete = 4 };
    enum RevType { None = 1,  Marked = 2, Unmarked = 4,  Accepted = 8, Rejected = 16, Cancelled = 32, Completed = 64 };
    QString author() const;
    void setAuthor( const QString &author );
    QString contents() const;
    void setContents( const QString &contents );
    QString uniqueName() const;
    void setUniqueName( const QString &uniqueName );
    QDateTime modificationDate() const;
    void setModificationDate( const QDateTime &date );
    QDateTime creationDate() const;
    void setCreationDate( const QDateTime &date );
    int flags() const;
    void setFlags( int flags );
    QRectF boundary() const;
    void setBoundary( const QRectF &boundary );
    struct Style {
        // appearance properties
        QColor          color;              // black
        double          opacity;            // 1.0
        // pen properties
        double          width;              // 1.0
        Poppler::Annotation::LineStyle       style;              // LineStyle::Solid
        double          xCorners;           // 0.0
        double          yCorners;           // 0.0
        int             marks;              // 3
        int             spaces;             // 0
        // pen effects
        Poppler::Annotation::LineEffect      effect;             // LineEffect::NoEffect
        double          effectIntensity;    // 1.0
        // default initializer
        Style();
    };
    Style style;

    struct Window {
        // window state (Hidden, FixedRotation, Deny* flags allowed)
        int             flags;              // -1 (never initialized) -> 0 (if inited and shown)
        // geometric properties
        QPointF         topLeft;            // no default, inited to boundary.topLeft
        int             width;              // no default
        int             height;             // no default
        // window contens/override properties
        QString         title;              // '' text in the titlebar (overrides author)
        QString         summary;            // '' short description (displayed if not empty)
        QString         text;               // '' text for the window (overrides annot->contents)
        // default initializer
        Window();
    };
    Window window;

    struct Revision {
        // child revision
        Poppler::Annotation *    annotation;         // not null
        // scope and type of revision
        Poppler::Annotation::RevScope        scope;              // Reply
        Poppler::Annotation::RevType         type;               // None
        // default initializer
        Revision();
    };

//    QLinkedList< Poppler::Annotation::Revision >& revisions();
    const QLinkedList< Poppler::Annotation::Revision >& revisions() const;
    virtual SubType subType() const = 0;
    virtual void store( QDomNode & parentNode, QDomDocument & document ) const;
    virtual ~Annotation();

private:
    Annotation(const Poppler::Annotation&);

%ConvertToSubClassCode
    switch (sipCpp->subType()) {
        case Poppler::Annotation::AText:
            sipType = sipType_Poppler_TextAnnotation;
            break;
        case Poppler::Annotation::ALine:
            sipType = sipType_Poppler_LineAnnotation;
            break;
        case Poppler::Annotation::AGeom:
            sipType = sipType_Poppler_GeomAnnotation;
            break;
        case Poppler::Annotation::AHighlight:
            sipType = sipType_Poppler_HighlightAnnotation;
            break;
        case Poppler::Annotation::AStamp:
            sipType = sipType_Poppler_StampAnnotation;
            break;
        case Poppler::Annotation::AInk:
            sipType = sipType_Poppler_InkAnnotation;
            break;
        case Poppler::Annotation::ALink:
            sipType = sipType_Poppler_LinkAnnotation;
            break;
        case Poppler::Annotation::ACaret:
            sipType = sipType_Poppler_CaretAnnotation;
            break;
        case Poppler::Annotation::AFileAttachment:
            sipType = sipType_Poppler_FileAttachmentAnnotation;
            break;
        case Poppler::Annotation::ASound:
            sipType = sipType_Poppler_SoundAnnotation;
            break;
        case Poppler::Annotation::AMovie:
            sipType = sipType_Poppler_MovieAnnotation;
            break;
        default:
            sipType = sipType_Poppler_Annotation;
    }

%End


}; // class Annotation


class TextAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    TextAnnotation();
    TextAnnotation( const QDomNode &node );
    virtual ~TextAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;
    
    enum TextType { Linked, InPlace };
    enum InplaceIntent { Unknown, Callout, TypeWriter };
    
    TextType textType() const;
    void setTextType( TextType type );
    
    QString textIcon() const;
    void setTextIcon( const QString &icon );
    
    QFont textFont() const;
    void setTextFont( const QFont &font );
    
    int inplaceAlign() const;
    void setInplaceAlign( int align );
    
    QString inplaceText() const;
    void setInplaceText( const QString &text );
    
    QPointF calloutPoint( int id ) const;
    void setCalloutPoint( int id, const QPointF &point );

    InplaceIntent inplaceIntent() const;
    void setInplaceIntent( InplaceIntent intent );

private:
    TextAnnotation(const Poppler::TextAnnotation&);
    
}; // class TextAnnotation


class LineAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    LineAnnotation();
    LineAnnotation( const QDomNode &node );
    virtual ~LineAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;

    enum TermStyle { Square, Circle, Diamond, OpenArrow, ClosedArrow, None,
                     Butt, ROpenArrow, RClosedArrow, Slash };
    enum LineIntent { Unknown, Arrow, Dimension, PolygonCloud };

    QLinkedList<QPointF> linePoints() const;
    void setLinePoints( const QLinkedList<QPointF> &points );

    TermStyle lineStartStyle() const;
    void setLineStartStyle( TermStyle style );

    TermStyle lineEndStyle() const;
    void setLineEndStyle( TermStyle style );

    bool isLineClosed() const;
    void setLineClosed( bool closed );

    QColor lineInnerColor() const;
    void setLineInnerColor( const QColor &color );

    double lineLeadingForwardPoint() const;
    void setLineLeadingForwardPoint( double point );

    double lineLeadingBackPoint() const;
    void setLineLeadingBackPoint( double point );

    bool lineShowCaption() const;
    void setLineShowCaption( bool show );

    LineIntent lineIntent() const;
    void setLineIntent( LineIntent intent );

private:
    LineAnnotation(const Poppler::LineAnnotation&);
    
}; // class LineAnnotation


class GeomAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    GeomAnnotation();
    GeomAnnotation( const QDomNode &node );
    virtual ~GeomAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;

    enum GeomType { InscribedSquare, InscribedCircle };

    GeomType geomType() const;
    void setGeomType( GeomType style );

    QColor geomInnerColor() const;
    void setGeomInnerColor( const QColor &color );

    int geomPointWidth() const;
    void setGeomPointWidth( int width );

private:
    GeomAnnotation(const Poppler::GeomAnnotation&);
    
}; // class GeomAnnotation


class HighlightAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    HighlightAnnotation();
    HighlightAnnotation( const QDomNode &node );
    virtual ~HighlightAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;
    enum HighlightType {
        Highlight,
        Squiggly,
        Underline,
        StrikeOut,
    };
//     struct Quad {
//         QPointF         points[4];
//         bool            capStart;
//         bool            capEnd;
//         double          feather;
//     };
    HighlightType highlightType() const;
    void setHighlightType( HighlightType type );
//     QList< Poppler::HighlightAnnotation::Quad > highlightQuads() const;
//     void setHighlightQuads( const QList< Poppler::HighlightAnnotation::Quad > &quads );

private:
    HighlightAnnotation(const Poppler::HighlightAnnotation&);
    
}; // class HighlightAnnotation


class StampAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    StampAnnotation();
    StampAnnotation( const QDomNode &node );
    virtual ~StampAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;
    QString stampIconName() const;
    void setStampIconName( const QString &name );
}; // class StampAnnotation


class InkAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    InkAnnotation();
    InkAnnotation( const QDomNode &node );
    virtual ~InkAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;

//     QList< QLinkedList<QPointF> > inkPaths() const;
//     void setInkPaths( const QList< QLinkedList<QPointF> > &paths );

private:
    InkAnnotation(const Poppler::InkAnnotation&);
    
}; // class InkAnnotation


class LinkAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    LinkAnnotation();
    LinkAnnotation( const QDomNode &node );
    virtual ~LinkAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;

    enum HighlightMode { None, Invert, Outline, Push };

    Poppler::Link* linkDestionation() const;
    void setLinkDestination( Poppler::Link *link );

    HighlightMode linkHighlightMode() const;
    void setLinkHighlightMode( HighlightMode mode );

    QPointF linkRegionPoint( int id ) const;
    void setLinkRegionPoint( int id, const QPointF &point );

private:
    LinkAnnotation(const Poppler::LinkAnnotation&);
    
}; // class LinkAnnotation


class CaretAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    CaretAnnotation();
    CaretAnnotation( const QDomNode &node );
    virtual ~CaretAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;
    enum CaretSymbol { None, P };
    CaretSymbol caretSymbol() const;
    void setCaretSymbol( CaretSymbol symbol );

private:
    CaretAnnotation(const Poppler::CaretAnnotation&);
    
}; // class CaretAnnotation


class FileAttachmentAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    FileAttachmentAnnotation();
    FileAttachmentAnnotation( const QDomNode &node );
    virtual ~FileAttachmentAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;
    QString fileIconName() const;
    void setFileIconName( const QString &icon );
    Poppler::EmbeddedFile* embeddedFile() const;
    void setEmbeddedFile( Poppler::EmbeddedFile *ef );

private:
    FileAttachmentAnnotation(const Poppler::FileAttachmentAnnotation&);
    
}; // class FileAttachmentAnnotation


class SoundAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    SoundAnnotation();
    SoundAnnotation( const QDomNode &node );
    virtual ~SoundAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;
    QString soundIconName() const;
    void setSoundIconName( const QString &icon );
    Poppler::SoundObject* sound() const;
    void setSound( Poppler::SoundObject *ef );

private:
    SoundAnnotation(const Poppler::SoundAnnotation&);
    
}; // class SoundAnnotation


class MovieAnnotation : Poppler::Annotation {
%TypeHeaderCode
#include <qt4/poppler-qt4.h>
#include <qt4/poppler-annotation.h>
%End

public:
    MovieAnnotation();
    MovieAnnotation( const QDomNode &node );
    virtual ~MovieAnnotation();
    virtual void store( QDomNode &parentNode, QDomDocument &document ) const;
    virtual SubType subType() const;

    Poppler::MovieObject* movie() const;
    void setMovie( Poppler::MovieObject *movie );
    QString movieTitle() const;
    void setMovieTitle( const QString &title );

private:
    MovieAnnotation(const Poppler::MovieAnnotation&);
    
}; // class MovieAnnotation


}; // namespace Poppler

/* kate: indent-width 4; space-indent on; hl c++; indent-mode cstyle; */
