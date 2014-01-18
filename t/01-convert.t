use strict;
use warnings;
use Test::More;
plan tests => 3 + blocks();
use Test::NoWarnings;
use Convert::TBX::Min 'min2basic';
use Test::Base;
use Test::XML;
use Test::LongString;

# TODO: someday use Test::XML::Ordered or something else to guarantee
# that titleStmt is before sourceDesc, which is enforced by the TBX
# Checker

sub convert {
    my $min = TBX::Min->new_from_xml(\$_);
    return ${min2basic($min)};
}
filters {input => 'convert'};

for my $block(blocks){
    is_xml($block->input, $block->expected, $block->name);
}

# separately test that the output has the required XML declaration
# and TBX-Basic doctype, both required by the TBX Checker. These are
# not tested by is_xml.
contains_string( (blocks)[0]->input,
    '<?xml version="1.0" encoding="UTF-8"?>',
    'output contains XML declaration');

contains_string( (blocks)[0]->input,
    '<!DOCTYPE martif SYSTEM "TBXBasiccoreStructV02.dtd">',
    'output contains doctype');

__DATA__
=== basic
--- input
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="en">
                    <tig>
                        <term>dog</term>
                    </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== subjectField
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <subjectField>whatever</subjectField>
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
            <descrip type="subjectField">whatever</descrip>
                <langSet xml:lang="en">
                    <tig>
                        <term>dog</term>
                    </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== full header
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
        <description>A short sample file demonstrating TBX-Min</description>
        <dateCreated>2013-11-12T00:00:00</dateCreated>
        <creator>Klaus-Dirk Schmidt</creator>
        <directionality>bidirectional</directionality>
        <license>CC BY license can be freely copied and modified</license>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>license: CC BY license can be freely copied and modified</p>
                <p>directionality: bidirectional</p>
                <p>description: A short sample file demonstrating TBX-Min</p>
                <p>creator: Klaus-Dirk Schmidt</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
            <p type="XCSURI">TBXBasicXCSV02.xcs</p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="en">
                    <tig>
                        <term>dog</term>
                    </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== multiple conceptEntries
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog1</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
        <conceptEntry id="C003">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog2</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="en">
                    <tig>
                        <term>dog1</term>
                    </tig>
                </langSet>
            </termEntry>
            <termEntry id="C003">
                <langSet xml:lang="en">
                    <tig>
                        <term>dog2</term>
                    </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== multiple langGroups
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="de">
                <termGroup>
                    <term>hund</term>
                </termGroup>
            </langGroup>
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="de">
                    <tig>
                        <term>hund</term>
                    </tig>
                </langSet>
                <langSet xml:lang="en">
                    <tig>
                        <term>dog</term>
                    </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== full termGroup
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                    <note>cute!</note>
                    <termStatus>preferred</termStatus>
                    <customer>SAP</customer>
                    <partOfSpeech>noun</partOfSpeech>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="en">
                <tig>
                  <term>dog</term>
                  <termNote type="administrativeStatus">preferredTerm-admn-sts</termNote>
                  <termNote type="partOfSpeech">noun</termNote>
                  <admin type="customerSubset">SAP</admin>
                  <note>cute!</note>
                </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== termStatus other values
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog1</term>
                    <termStatus>preferred</termStatus>
                </termGroup>
                <termGroup>
                    <term>dog2</term>
                    <termStatus>admitted</termStatus>
                </termGroup>
                <termGroup>
                    <term>dog3</term>
                    <termStatus>notRecommended</termStatus>
                </termGroup>
                <termGroup>
                    <term>dog4</term>
                    <termStatus>obsolete</termStatus>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="en">
                  <tig>
                    <term>dog1</term>
                    <termNote type="administrativeStatus">preferredTerm-admn-sts</termNote>
                  </tig>
                  <tig>
                    <term>dog2</term>
                    <termNote type="administrativeStatus">admittedTerm-admn-sts</termNote>
                  </tig>
                  <tig>
                    <term>dog3</term>
                    <termNote type="administrativeStatus">deprecatedTerm-admn-sts</termNote>
                  </tig>
                  <tig>
                    <term>dog4</term>
                    <termNote type="administrativeStatus">supersededTerm-admn-sts</termNote>
                  </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

=== partOfSpeech other values
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog1</term>
                    <partOfSpeech>noun</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog2</term>
                    <partOfSpeech>verb</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog3</term>
                    <partOfSpeech>adjective</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog4</term>
                    <partOfSpeech>adverb</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog5</term>
                    <partOfSpeech>properNoun</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog6</term>
                    <partOfSpeech>other</partOfSpeech>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>
--- expected
<martif type="TBX-Basic" xml:lang="de">
    <martifHeader>
        <fileDesc>
            <titleStmt>
                <title>TBX sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX sample (generated from UTX)</p>
            </sourceDesc>
        </fileDesc>
        <encodingDesc>
                <p type="XCSURI">TBXBasicXCSV02.xcs
                </p>
        </encodingDesc>
    </martifHeader>
    <text>
        <body>
            <termEntry id="C002">
                <langSet xml:lang="en">
                  <tig>
                    <term>dog1</term>
                    <termNote type="partOfSpeech">noun</termNote>
                  </tig>
                  <tig>
                    <term>dog2</term>
                    <termNote type="partOfSpeech">verb</termNote>
                  </tig>
                  <tig>
                    <term>dog3</term>
                    <termNote type="partOfSpeech">adjective</termNote>
                  </tig>
                  <tig>
                    <term>dog4</term>
                    <termNote type="partOfSpeech">adverb</termNote>
                  </tig>
                  <tig>
                    <term>dog5</term>
                    <termNote type="partOfSpeech">properNoun</termNote>
                  </tig>
                  <tig>
                    <term>dog6</term>
                    <termNote type="partOfSpeech">other</termNote>
                  </tig>
                </langSet>
            </termEntry>
        </body>
    </text>
</martif>

