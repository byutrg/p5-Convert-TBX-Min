use strict;
use warnings;
use Test::More;
plan tests => 1+blocks();
use Test::NoWarnings;
use Convert::TBX::Min 'min2basic';
use Test::Base;
use Test::XML;

sub convert {
    my $min = TBX::Min->new_from_xml(\$_);
    return ${min2basic($min)};
}
filters {input => 'convert'};

for my $block(blocks){
    print "got " . $block->input;
    is_xml($block->input, $block->expected, $block->name);
}

__DATA__
=== basic header
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
                <title>TBX Sample</title>
            </titleStmt>
            <sourceDesc>
                <p>TBX Sample (generated from UTX)</p>
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
