#!/usr/bin/python
import glob
import os
from collections import namedtuple

def convertFile(path):
    Node = namedtuple('Node', ['x', 'y'])
    Element = namedtuple('Element', ['first', 'second', 'third'])
    nodes = dict()
    elements = dict()

    section = None
    with open(path) as inp:
        for line in inp:
            line = [line.replace(',', '').strip() for line in line.split()]
            if not len(line): continue
            if line[0] == '**': continue
            if line[0].startswith('*'):
                section = line[0][1:]
                continue

            if section == 'Node':
                nodes[int(line[0])] = Node(float(line[1]), float(line[2]))

            if section == 'Element':
                elements[int(line[0])] = Element(int(line[1]), int(line[2]), int(line[3]))
    outPath = '{}.m'.format(path.replace('.', '_').replace('-', '_'))
    with open(outPath, 'w') as out:
        print('overwriting {}'.format(outPath))
        out.write(Config(nodes, elements).output_text)

def getNaturalBoundaries(nodes, elements):
    n_bc = []
    for element in elements.itervalues():
        naturalNodes = [node for node in element
                        if nodes[node].x == 5 or nodes[node].x == -5]
        if len(naturalNodes) == 2:
            value0 = -1 if nodes[naturalNodes[0]].x == -5 else 1
            value1 = -1 if nodes[naturalNodes[1]].x == -5 else 1
            n_bc.append([naturalNodes[0], naturalNodes[1], value0, value1])
    return n_bc
        

class Config(object):
    def __init__(self, nodes, elements, ngp=2):
        self.nodes = nodes
        self.elements = elements

        isEssentialBoundary = lambda node: node.x == 5 and node.y == -2.5
        self.flags = [2 if isEssentialBoundary(node) else 0 for node in nodes.itervalues()]
        self.e_bc = [0 for flag in self.flags]
        self.nd = len([flag for flag in self.flags if flag == 2])

        self.n_bc = getNaturalBoundaries(self.nodes, self.elements)
        self.nbe = len(self.n_bc)
        self.n_bc = '[{}\n{}\n{}\n{}]'.format(' '.join([str(edge[0]) for edge in self.n_bc]),
                                              ' '.join([str(edge[1]) for edge in self.n_bc]),
                                              ' '.join([str(edge[2]) for edge in self.n_bc]),
                                              ' '.join([str(edge[3]) for edge in self.n_bc]))
       
        self.ngp = ngp 
        self.nnp = len(nodes)
        self.nel = len(elements)
        self.x = '[{}]'.format(' '.join([str(node.x) for node in self.nodes.itervalues()]))
        self.y = '[{}]'.format(' '.join([str(node.y) for node in self.nodes.itervalues()]))
        self.IEN = '[{}]'.format(''.join(['{} {} {}\n'.format(elm.first, elm.second, elm.third)
                                             for elm in self.elements.itervalues()]))

        with open('convert_inputs.tmpl', 'r') as tmpl:
            self.template = tmpl.read()
            self.output_text = self.template.format(nnp=self.nnp,
                                                    nel=self.nel,
                                                    ngp=self.ngp,
                                                    x=self.x,
                                                    y=self.y,
                                                    IEN=self.IEN,
                                                    flags=self.flags,
                                                    e_bc=self.e_bc,
                                                    nd=self.nd,
                                                    n_bc=self.n_bc,
                                                    nbe=self.nbe)


def main():
    for path in glob.glob('*.inp'):
        convertFile(path)

if __name__ == "__main__":
    main()
